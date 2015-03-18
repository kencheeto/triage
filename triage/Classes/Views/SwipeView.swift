//
//  SwipeView.swift
//  triage
//
//  Created by Kenshiro Nakagawa on 3/15/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

class SwipeView: UIView {

  @IBOutlet private var contentView: UIView!
  @IBOutlet weak var rightLabel: UILabel!
  @IBOutlet weak var leftLabel: UILabel!

  private var origin: CGPoint!
  private var width: CGFloat!
  private var farRightOffset: CGFloat!
  private var deadOffset: CGFloat!

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initSubviews()
  }

  init(frame: CGRect, origin: CGPoint) {
    super.init(frame: frame)
    self.origin = origin
    width = frame.width
    farRightOffset = width * 0.4
    deadOffset = width * 0.15

    initSubviews()
  }

  func initSubviews() {
    let nib = UINib(nibName: "SwipeView", bundle: nil)
    nib.instantiateWithOwner(self, options: nil)
    contentView.frame = bounds
    addSubview(contentView)
  }

  var offset: CGFloat? {
    didSet {
      if offset > farRightOffset {
        contentView.backgroundColor = Colors.MoonYellow
        rightLabel.text = "macro"
        leftLabel.text = ""
      } else if offset > deadOffset {
        contentView.backgroundColor = Colors.ZendeskGreen
        rightLabel.text = "tier 1"
        leftLabel.text = ""
      } else if offset > -deadOffset {
        contentView.backgroundColor = UIColor.lightGrayColor()
        rightLabel.text = "tier 1"
        leftLabel.text = "trash"
      } else {
        contentView.backgroundColor = UIColor.redColor()
        rightLabel.text = ""
        leftLabel.text = "trash"
      }

      if offset > 0 {
        center = CGPoint(x: origin.x + offset! - width, y: origin.y)
      } else {
        center = CGPoint(x: origin.x + offset! + width, y: origin.y)
      }
    }
  }
}
