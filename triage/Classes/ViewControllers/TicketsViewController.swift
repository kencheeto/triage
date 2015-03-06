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

    ticketsTableView.registerClass(
      TicketTableViewCell.self,
      forCellReuseIdentifier: "TicketTableViewCell"
    )
    ticketsTableView.delegate = self
    ticketsTableView.dataSource = self
    ticketsTableView.layoutMargins = UIEdgeInsetsZero
    ticketsTableView.separatorInset = UIEdgeInsetsZero
    ticketsTableView.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)

    ticketsTableView.reloadData()
  }

  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let ticket = tickets!.items[indexPath.row]
    let cell = ticketsTableView.dequeueReusableCellWithIdentifier(
      "TicketTableViewCell"
    ) as TicketTableViewCell

    cell.ticket = ticket

    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tickets!.items.count
  }
}
