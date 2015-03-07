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
  private var origin: CGPoint!

  required init(coder: NSCoder) {
    super.init(coder: coder)

    let recognizer = UIPanGestureRecognizer(target: self, action: "didPan:")
    recognizer.delegate = self
    addGestureRecognizer(recognizer)
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    userAvatar.backgroundColor = UIColor.cyanColor()
    subjectLabel.preferredMaxLayoutWidth = subjectLabel.frame.size.width
    descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.size.width
  }

  func didPan(recognizer: UIPanGestureRecognizer) {
    if recognizer.state == .Began {
      origin = center
    } else if recognizer.state == .Changed {
      let translation = recognizer.translationInView(self)
      if translation.x > frame.width * 0.6 {
        superview?.backgroundColor = UIColor.purpleColor()
      } else if translation.x > frame.width * 0.15 {
        superview?.backgroundColor = UIColor.greenColor()
      } else if translation.x > frame.width * -0.15 {
        superview?.backgroundColor = UIColor.whiteColor()
      } else {
        superview?.backgroundColor = UIColor.redColor()
      }
      center = CGPoint(x: origin.x + translation.x, y: origin.y)
    } else if recognizer.state == .Ended {
      center = origin
    }
  }
}