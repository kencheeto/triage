//
//  SwipeView.swift
//  triage
//
//  Created by Kenshiro Nakagawa on 3/15/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

class SwipeView: UIView {

  @IBOutlet var contentView: UIView!

  var origin: CGPoint!

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

    initSubviews()
  }

  func initSubviews() {
    let nib = UINib(nibName: "SwipeView", bundle: nil)
    nib.instantiateWithOwner(self, options: nil)
    contentView.frame = bounds
    width = frame.width
    farRightOffset = width * 0.5
    deadOffset = width * 0.15
    addSubview(contentView)
  }

  var offset: CGFloat? {
    didSet {
      if offset > farRightOffset {
        contentView.backgroundColor = Colors.MoonYellow
      } else if offset > deadOffset {
        contentView.backgroundColor = Colors.ZendeskGreen
      } else if offset > -deadOffset {
        contentView.backgroundColor = UIColor.whiteColor()
      } else {
        contentView.backgroundColor = UIColor.redColor()
      }

      if offset > 0 {
        center = CGPoint(x: origin.x + offset! - width, y: origin.y)
      } else {
        center = CGPoint(x: origin.x + offset! + width, y: origin.y)
      }
    }
  }
}
