//
//  TicketsViewController.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

class TicketsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  var tickets: Tickets?

  @IBOutlet weak var ticketsTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    ticketsTableView.rowHeight = UITableViewAutomaticDimension;
    ticketsTableView.estimatedRowHeight = 44
    ticketsTableView.delegate = self
    ticketsTableView.dataSource = self
    ticketsTableView.layoutMargins = UIEdgeInsetsZero
    ticketsTableView.separatorInset = UIEdgeInsetsZero
    ticketsTableView.tableFooterView = UIView(frame: CGRectZero)

    ticketsTableView.reloadData()
  }

  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let ticket = tickets!.items[indexPath.row]
    let cell = ticketsTableView.dequeueReusableCellWithIdentifier(
      "TicketTableViewCell", forIndexPath: indexPath
    ) as TicketTableViewCell

    cell.layoutMargins = UIEdgeInsetsZero
    cell.ticket = ticket
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
