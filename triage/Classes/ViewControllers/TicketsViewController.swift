//
//  TicketsViewController.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

class TicketsViewController: UIViewController {

  private let API = ZendeskAPI.instance

  var tickets: Tickets?

  @IBOutlet weak var ticketsTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

//    API.getViews(success: nil, failure: nil)
    tickets = Tickets(fixture: "tickets")

    ticketsTableView.rowHeight = UITableViewAutomaticDimension;
    ticketsTableView.estimatedRowHeight = 44
    ticketsTableView.delegate = self
    ticketsTableView.dataSource = self
    ticketsTableView.layoutMargins = UIEdgeInsetsZero
    ticketsTableView.separatorInset = UIEdgeInsetsZero
    ticketsTableView.tableFooterView = UIView(frame: CGRectZero)

    ticketsTableView.reloadData()
  }
}

extension TicketsViewController: UITableViewDelegate {
  
}

extension TicketsViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let ticket = tickets!.items[indexPath.row]
    let cell = ticketsTableView.dequeueReusableCellWithIdentifier(
      "TicketTableViewCell", forIndexPath: indexPath
    ) as TicketTableViewCell

    cell.layoutMargins = UIEdgeInsetsZero
    cell.ticket = ticket
    cell.delegate = self
    cell.updateConstraintsIfNeeded()

    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tickets != nil {
      return tickets!.items.count
    } else {
      return 0
    }
  }
}

extension TicketsViewController: TicketTableViewCellDelegate {
  func didFarRightSwipe(cell: TicketTableViewCell) {
    println("didFarRightSwipe")
  }

  func didNearRightSwipe(cell: TicketTableViewCell) {
    println("didNearRightSwipe")
  }

  func didLeftSwipe(cell: TicketTableViewCell) {
    println("didLeftRightSwipe")
  }

}