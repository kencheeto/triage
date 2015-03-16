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
  func didTap(cell: TicketTableViewCell)
}

class TicketTableViewCell: UITableViewCell, UIGestureRecognizerDelegate {

  var ticket: Ticket? {
    didSet {
      if let t = ticket {
        subjectLabel.text = t.subject
        descriptionLabel.text = t.description
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

  private var panGestureRecognizer: UIPanGestureRecognizer!
  private var tapGestureRecognizer: UITapGestureRecognizer!
  private var origin: CGPoint!
  var delegate: TicketsViewController!
  var swipeView: UIView!
  private var deadX: CGFloat!
  private var farRightX: CGFloat!
  private var cellWidth: CGFloat!
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    subjectLabel.preferredMaxLayoutWidth = subjectLabel.frame.size.width
    descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.size.width
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    
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
//    ticketView.addGestureRecognizer(tapGestureRecognizer)
    deadX = frame.width * 0.15
    farRightX = frame.width * 0.5
    cellWidth = frame.width
    origin = ticketView.center
  }

  
  func didPan(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translationInView(self)
    if recognizer.state == .Began {
      swipeView = UIView(frame: frame)
      swipeView.center = origin
      insertSubview(swipeView, aboveSubview: ticketView)
    } else if recognizer.state == .Changed {
      if translation.x > farRightX {
        swipeView.backgroundColor = Colors.MoonYellow
      } else if translation.x > deadX {
        swipeView.backgroundColor = Colors.ZendeskGreen
      } else if translation.x > -deadX {
        swipeView.backgroundColor = UIColor.whiteColor()
      } else {
        swipeView.backgroundColor = UIColor.redColor()
      }
      ticketView.center = CGPoint(x: origin.x + translation.x, y: origin.y)
      if translation.x > 0 {
        swipeView.center = CGPoint(x: origin.x + translation.x - cellWidth, y: origin.y)
      } else {
        swipeView.center = CGPoint(x: origin.x + translation.x + cellWidth, y: origin.y)
      }
    } else if recognizer.state == .Ended {
      if translation.x > farRightX {
        swipeView.center = origin
        delegate?.didFarRightSwipe(self)
        return
      } else if translation.x > deadX {
        delegate?.didNearRightSwipe(self)
      } else if translation.x > -deadX {
        UIView.animateWithDuration(0.2, animations: {
          self.ticketView.center = self.origin
        })
      } else {
        delegate?.didLeftSwipe(self)
      }
      swipeView.removeFromSuperview()
    }
  }
    
  func didTap(recognizer: UIPanGestureRecognizer) {
    delegate?.didTap(self)
  }

  override func gestureRecognizerShouldBegin(
    gestureRecognizer: UIGestureRecognizer) -> Bool {
        
    if gestureRecognizer.isKindOfClass(UIPanGestureRecognizer){
      let panGestureRecognizer = gestureRecognizer as UIPanGestureRecognizer
      let translation = panGestureRecognizer.translationInView(
      panGestureRecognizer.view!
    )

      return fabs(translation.x) > fabs(translation.y)
    } else{
      return true
    }
  }
}
