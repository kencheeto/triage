//
//  MacrosTableViewCell.swift
//  triage
//
//  Created by Kurt Ruppel on 3/15/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

class MacrosTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!

  var ticket: Ticket?

  var macro: Macro? {
    didSet {
      titleLabel.text = macro?.title
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    titleLabel.textColor = Colors.Oil
    titleLabel.font = UIFont(name: "ProximaNova-Regular", size: 15.0)
  }
}
