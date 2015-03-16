//
//  MacrosTableHeaderView.swift
//  triage
//
//  Created by Kurt Ruppel on 3/15/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

class MacrosTableHeaderView: UIView {

  lazy private var notificationCenter: NSNotificationCenter =
    NSNotificationCenter.defaultCenter()

  lazy private var label = UILabel()
  lazy private var closeButton = UIButton()

  private var tapGestureRecognizer: UITapGestureRecognizer?

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    backgroundColor = Colors.MoonYellow
    label.font = UIFont(name: "HelveticaNeue", size: 16.0)
    label.textColor = Colors.Snow
    label.text = "Apply a macro"
    label.numberOfLines = 0
    label.preferredMaxLayoutWidth = label.frame.size.width

    closeButton.setTitle("✕", forState: .allZeros)
    closeButton.titleLabel?.textColor = Colors.Snow
    closeButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)

    addSubview(label)
    addSubview(closeButton)

    let views = [
      "label": label,
      "close": closeButton
    ]

    addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-10-[label]-10-|",
        options: nil,
        metrics: nil,
        views: views
      )
    )
    addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-4-[close]",
        options: nil,
        metrics: nil,
        views: views
      )
    )
    addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-20-[label]-(>=10)-[close]-10-|",
        options: nil,
        metrics: nil,
        views: views
      )
    )

    tapGestureRecognizer = UITapGestureRecognizer(
      target: self, action: "didClose:"
    )
    closeButton.addGestureRecognizer(tapGestureRecognizer!)
  }

  func didClose(recognizer: UITapGestureRecognizer) {
    notificationCenter.postNotificationName(
      "macros:close",
      object: nil
    )
  }

  override func addSubview(view: UIView) {
    super.addSubview(view)

    view.setTranslatesAutoresizingMaskIntoConstraints(false)
  }
}
