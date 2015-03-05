//
//  TicketTableViewCell.swift
//  triage
//
//  Created by Kurt Ruppel on 3/5/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

  var ticket: Ticket? {
    didSet {
      subjectLabel.text = ticket?.data["subject"].string!
    }
  }

  @IBOutlet var subjectLabel: UILabel!

  required init(coder: NSCoder) {
    fatalError("init(coder: has not been implemented")
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    let nib = UINib(nibName: "TicketTableViewCell", bundle: nil)

    super.init(style: style, reuseIdentifier: reuseIdentifier)
    nib.instantiateWithOwner(self, options: nil)

    layoutMargins = UIEdgeInsetsZero
    subjectLabel.frame = bounds
    addSubview(subjectLabel)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }
}