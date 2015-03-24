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
      if let t = ticket {
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        paragraphStyle.lineSpacing = 4.0
        paragraphStyle.lineBreakMode = .ByTruncatingTail

        let attributes = [
          NSParagraphStyleAttributeName: paragraphStyle
        ]
        let attributedString = NSAttributedString(
          string: t.description,
          attributes: attributes
        )

        subjectLabel.text = t.subject
        descriptionLabel.attributedText = attributedString
        ticketCreatedAtLabel.text = t.createdAtInWords()

        if let r = t.requester? {
          userNameLabel.text = r.fields.name
          userAvatar.setImageWithURL(NSURL(string: r.avatarURL()))
        } else {
          userNameLabel.text = ""
        }

      } else {
        subjectLabel.text = "no ticket"
        descriptionLabel.text = "no ticket"
        ticketCreatedAtLabel.text = "no ticket"
      }
    }
  }

  @IBOutlet weak var ticketView: UIView!
  @IBOutlet weak var userAvatar: UIImageView!
  @IBOutlet weak var subjectLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var ticketCreatedAtLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!

  var delegate: TicketsViewController!
  var swipeView: SwipeView!

  private var panGestureRecognizer: UIPanGestureRecognizer!
  private var tapGestureRecognizer: UITapGestureRecognizer!
  private var origin: CGPoint!
  private var deadZoneEndX: CGFloat!
  private var macroZoneStartX: CGFloat!
  private var cellWidth: CGFloat!

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    panGestureRecognizer = UIPanGestureRecognizer(
      target: self,
      action: "didPan:"
    )
    panGestureRecognizer.delegate = self
    ticketView.addGestureRecognizer(panGestureRecognizer)

    tapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: "didTap:"
    )
    tapGestureRecognizer.delegate = self

    userAvatar.layer.cornerRadius = userAvatar.bounds.width / 2
    userAvatar.layer.borderColor = Colors.Gainsboro.CGColor
    userAvatar.layer.borderWidth = 1.0
    userAvatar.layer.masksToBounds = true

    subjectLabel.font = UIFont(name: "ProximaNova-Sbold", size: 18.0)
    subjectLabel.preferredMaxLayoutWidth = subjectLabel.frame.size.width
    descriptionLabel.textColor = Colors.Oil
    descriptionLabel.font = UIFont(name: "ProximaNova-Regular", size: 14.0)
    descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.size.width
    descriptionLabel.textColor = Colors.DarkGray
    ticketCreatedAtLabel.font = UIFont(name: "ProximaNova-Regular", size: 14.0)
    ticketCreatedAtLabel.textColor = Colors.Aluminum
    userNameLabel.font = UIFont(name: "ProximaNova-Regular", size: 14.0)
    userNameLabel.textColor = Colors.Aluminum
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    // the gray dead swipe zone ends
    deadZoneEndX = frame.width * 0.15
    // the macro swipe zone begins
    macroZoneStartX = frame.width * 0.4
    cellWidth = frame.width
  }

  func didPan(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translationInView(self)
    if recognizer.state == .Began {
      origin = ticketView.center
      swipeView = SwipeView(frame: frame)
      swipeView.origin = origin
      swipeView.deadZoneEndX = deadZoneEndX
      swipeView.macroZoneStartX = macroZoneStartX
      swipeView.cellWidth = cellWidth
      insertSubview(swipeView, aboveSubview: ticketView)
    } else if recognizer.state == .Changed {
      swipeView.offset = translation.x
      ticketView.center = CGPoint(x: origin.x + translation.x, y: origin.y)
    } else if recognizer.state == .Ended {
      if translation.x > macroZoneStartX {
        swipeView.center = origin
        delegate?.didFarRightSwipe(self)
        return
      } else if translation.x > deadZoneEndX {
        delegate?.didNearRightSwipe(self)
      } else if translation.x > -deadZoneEndX {
        UIView.animateWithDuration(
          0.4,
          delay: 0,
          usingSpringWithDamping: 0.75,
          initialSpringVelocity: 0,
          options: nil,
          animations: {
            self.ticketView.center = self.origin
            self.swipeView.alpha = 0
          },
          completion: nil
        )
      } else {
        delegate?.didLeftSwipe(self)
      }
      swipeView.removeFromSuperview()
    }
  }

  override func gestureRecognizerShouldBegin(
    gestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer.isKindOfClass(UIPanGestureRecognizer){
      let panGestureRecognizer = gestureRecognizer as UIPanGestureRecognizer
      let translation = panGestureRecognizer.translationInView(
        panGestureRecognizer.view!
      )

      return fabs(translation.x) > fabs(translation.y)
    } else {
      return true
    }
  }
}
