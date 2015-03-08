//
//  TicketsViewController.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

let kViewID = 47205968

class TicketsViewController: UIViewController {

  private let API = ZendeskAPI.instance

  var rows: [TicketFilterRow] = []

  private var parameters: [String: AnyObject] {
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

  override func viewDidLoad() {
    super.viewDidLoad()

    API.executeView(kViewID, parameters: parameters, success: didFetchRows, failure: nil)

    ticketsTableView.rowHeight = UITableViewAutomaticDimension;
    ticketsTableView.estimatedRowHeight = 44
    ticketsTableView.delegate = self
    ticketsTableView.dataSource = self
    ticketsTableView.layoutMargins = UIEdgeInsetsZero
    ticketsTableView.separatorInset = UIEdgeInsetsZero
    ticketsTableView.tableFooterView = UIView(frame: CGRectZero)

    ticketsTableView.reloadData()
  }

  func didFetchRows(operation: AFHTTPRequestOperation!, rows: [TicketFilterRow]) {
    self.rows = rows
    ticketsTableView.reloadData()
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
    println("didNearRightSwipe")
  }

  func didLeftSwipe(cell: TicketTableViewCell) {
    println("didLeftRightSwipe")
  }

}