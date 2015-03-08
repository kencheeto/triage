//
//  TicketTableViewCell.swift
//  triage
//
//  Created by Kurt Ruppel on 3/5/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

protocol TicketTableViewCellDelegate {
  func didNearRightSwipe(cell: TicketTableViewCell)
  func didFarRightSwipe(cell: TicketTableViewCell)
  func didLeftSwipe(cell: TicketTableViewCell)
}

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
  var delegate: TicketsViewController!
  
  required init(coder: NSCoder) {
    super.init(coder: coder)

    let recognizer = UIPanGestureRecognizer(target: self, action: "didPan:")
    recognizer.delegate = self
    addGestureRecognizer(recognizer)
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    subjectLabel.preferredMaxLayoutWidth = subjectLabel.frame.size.width
    descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.size.width
  }

  func didPan(recognizer: UIPanGestureRecognizer) {
    let deadX = frame.width * 0.15
    let farRightX = frame.width * 0.5
    let translation = recognizer.translationInView(self)
    if recognizer.state == .Began {
      origin = center
    } else if recognizer.state == .Changed {
      if translation.x > farRightX {
        superview?.backgroundColor = UIColor.purpleColor()
      } else if translation.x > deadX {
        superview?.backgroundColor = Colors.ZendeskGreen
      } else if translation.x > -deadX {
        superview?.backgroundColor = UIColor.whiteColor()
      } else {
        superview?.backgroundColor = UIColor.redColor()
      }
      center = CGPoint(x: origin.x + translation.x, y: origin.y)
    } else if recognizer.state == .Ended {
      if translation.x > farRightX {
        delegate?.didFarRightSwipe(self)
      } else if translation.x > deadX {
        delegate?.didNearRightSwipe(self)
      } else if translation.x > -deadX {
        // noop
      } else {
        delegate?.didLeftSwipe(self)
      }
      center = origin
    }
  }
}