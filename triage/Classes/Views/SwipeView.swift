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

  var origin: CGPoint!
  var cellWidth: CGFloat!
  var macroZoneStartX: CGFloat!
  var deadZoneEndX: CGFloat!

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initSubviews()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    alpha = 0
    initSubviews()
  }

  func initSubviews() {
    let nib = UINib(nibName: "SwipeView", bundle: nil)
    nib.instantiateWithOwner(self, options: nil)
    rightLabel.font = UIFont(name: "ProximaNova-Regular", size: 20.0)
    rightLabel.textColor = UIColor.whiteColor()
    leftLabel.font = UIFont(name: "ProximaNova-Regular", size: 20.0)
    leftLabel.textColor = UIColor.whiteColor()
    contentView.frame = bounds
    addSubview(contentView)
  }

  var offset: CGFloat? {
    didSet {
      if offset > macroZoneStartX {
        contentView.backgroundColor = Colors.MoonYellow
        rightLabel.text = "macro"
        leftLabel.text = ""
      } else if offset > deadZoneEndX {
        contentView.backgroundColor = Colors.Forest
        rightLabel.text = "tier 1"
        leftLabel.text = ""
      } else if offset > 0 {
        contentView.backgroundColor = Colors.Kermit
        rightLabel.text = "tier 1"
        leftLabel.text = "trash"
      } else if offset > -deadZoneEndX {
          contentView.backgroundColor = Colors.IndianRed
          rightLabel.text = "tier 1"
          leftLabel.text = "trash"
      } else {
        contentView.backgroundColor = Colors.DarkPastelRed
        rightLabel.text = ""
        leftLabel.text = "trash"
      }

      alpha = abs(offset!) / deadZoneEndX

      if offset > 0 {
        center = CGPoint(x: origin.x + offset! - cellWidth, y: origin.y)
      } else {
        center = CGPoint(x: origin.x + offset! + cellWidth, y: origin.y)
      }
    }
  }
}
