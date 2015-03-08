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

class TicketTableViewCell: UITableViewCell, UIGestureRecognizerDelegate {

  var ticket: Ticket? {
    didSet {
      subjectLabel.text = ticket?.subject
      descriptionLabel.text = ticket?.description
    }
  }

  @IBOutlet weak var userAvatar: UIImageView!
  @IBOutlet weak var subjectLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  private var panGestureRecognizer: UIPanGestureRecognizer!
  private var origin: CGPoint!
  var delegate: TicketsViewController!
  
  required init(coder: NSCoder) {
    super.init(coder: coder)

    panGestureRecognizer = UIPanGestureRecognizer(
      target: self,
      action: "didPan:"
    )
    panGestureRecognizer.delegate = self
    addGestureRecognizer(panGestureRecognizer)
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

  override func gestureRecognizerShouldBegin(
    gestureRecognizer: UIGestureRecognizer) -> Bool {
    let panGestureRecognizer = gestureRecognizer as UIPanGestureRecognizer
    let translation = panGestureRecognizer.translationInView(
      panGestureRecognizer.view!
    )

    return fabs(translation.x) > fabs(translation.y)
  }
}