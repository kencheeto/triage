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
      descriptionLabel.text = ticket?.metadata["description"]?.string!
    }
  }

  @IBOutlet weak var userAvatar: UIImageView!
  @IBOutlet weak var subjectLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    layoutMargins = UIEdgeInsetsZero

    userAvatar.backgroundColor = UIColor.cyanColor()
    subjectLabel.preferredMaxLayoutWidth = subjectLabel.frame.size.width
    descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.size.width
  }
}