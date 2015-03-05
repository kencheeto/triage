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

  @IBOutlet weak var currentUserLabel: UILabel!
  @IBOutlet weak var ticketsTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    ticketsTableView.registerClass(
      TicketTableViewCell.self,
      forCellReuseIdentifier: "TicketTableViewCell"
    )

    if var user = User.currentUser {
      currentUserLabel.text = user.name
    }

    ticketsTableView.delegate = self
    ticketsTableView.dataSource = self

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
