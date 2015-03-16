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

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initSubviews()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
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
      contentView.backgroundColor = colorForOffset(offset!)
    }
  }

  var farRightOffset: CGFloat! {
    return contentView.frame.width * 0.5
  }

  var deadOffset: CGFloat! {
    return contentView.frame.width * 0.15
  }

  func colorForOffset(offset: CGFloat) -> UIColor {
    if offset > farRightOffset {
      return Colors.MoonYellow
    } else if offset > deadOffset {
      return Colors.ZendeskGreen
    } else if offset > -deadOffset {
      return UIColor.whiteColor()
    } else {
      return UIColor.redColor()
    }
  }
}
