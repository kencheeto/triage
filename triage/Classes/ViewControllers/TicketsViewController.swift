//
//  TicketsViewController.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

let kViewID = 47205968
let kAssignToTier1MacroID = 47314978
let kAssignToTrashAgent = 47314477

class TicketsViewController: UIViewController {

  private let API = ZendeskAPI.instance

  var macros: [Macro] = []
  var rows: [TicketFilterRow] = []

  private var parameters: NSDictionary {
    get {
      return [
        "per_page": 30,
        "page": 1,
        "sort_order": "desc",
        "group_by": "+",
        "include": "via_id"
      ]
    }
  }

  @IBOutlet weak var ticketsTableView: UITableView!
  lazy private var refreshControl: UIRefreshControl = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchMacros()
    fetchTickets()

    ticketsTableView.rowHeight = UITableViewAutomaticDimension;
    ticketsTableView.estimatedRowHeight = 44
    ticketsTableView.delegate = self
    ticketsTableView.dataSource = self
    ticketsTableView.layoutMargins = UIEdgeInsetsZero
    ticketsTableView.separatorInset = UIEdgeInsetsZero
    ticketsTableView.tableFooterView = UIView(frame: CGRectZero)

    refreshControl.addTarget(
      self,
      action: "didBeginRefresh:",
      forControlEvents: .ValueChanged
    )
    ticketsTableView.insertSubview(refreshControl, atIndex: 0)

    ticketsTableView.reloadData()
  }

  func fetchMacros() {
    API.getMacros(success: didFetchMacros, failure: nil)
  }

  func fetchTickets() {
    API.executeView(kViewID, parameters: parameters, success: didFetchRows, failure: nil)
  }

  func didFetchMacros(operation: AFHTTPRequestOperation!, macros: [Macro]) {
    self.macros = macros
  }

  func didFetchRows(operation: AFHTTPRequestOperation!, rows: [TicketFilterRow]) {
    self.rows = rows
    ticketsTableView.reloadData()
    refreshControl.endRefreshing()
  }

  func didBeginRefresh(sender: UIRefreshControl) {
    sender.beginRefreshing()
    fetchTickets()
  }
}

extension TicketsViewController: UITableViewDelegate {
  
}

extension TicketsViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let row = rows[indexPath.row]
    let cell = ticketsTableView.dequeueReusableCellWithIdentifier(
      "TicketTableViewCell", forIndexPath: indexPath
    ) as TicketTableViewCell

    cell.layoutMargins = UIEdgeInsetsZero
    cell.ticket = row.ticket
    cell.delegate = self
    cell.updateConstraintsIfNeeded()

    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }
}

extension TicketsViewController: TicketTableViewCellDelegate {
  func didFarRightSwipe(cell: TicketTableViewCell) {
    println("didFarRightSwipe")
  }

  func didNearRightSwipe(cell: TicketTableViewCell) {
    let indexPath = ticketsTableView.indexPathForCell(cell)!

    rows.removeAtIndex(indexPath.row)
    ticketsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)

    API.applyMacroToTicket(
      kAssignToTier1MacroID,
      ticketID: cell.ticket!.id,
      success: { (operation: AFHTTPRequestOperation!, result: MacroResult) -> Void in
        let ticket = result.ticket

        cell.ticket = ticket

        ticket.save(success: nil, failure: nil)
      },
      failure: nil
    )
    println("didNearRightSwipe")
  }

  func didLeftSwipe(cell: TicketTableViewCell) {
    let indexPath = ticketsTableView.indexPathForCell(cell)!

    rows.removeAtIndex(indexPath.row)
    ticketsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)

    API.applyMacroToTicket(
      kAssignToTrashAgent,
      ticketID: cell.ticket!.id,
      success: { (operation: AFHTTPRequestOperation!, result: MacroResult) -> Void in
        let ticket = result.ticket

        cell.ticket = ticket

        ticket.save(success: nil, failure: nil)
      },
      failure: nil
    )
    println("didLeftRightSwipe")
  }
}