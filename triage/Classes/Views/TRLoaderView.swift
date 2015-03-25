//
//  TRLoaderView.swift
//  triage
//
//  Created by Kurt Ruppel on 3/24/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

let kLCoordinates = [
  (2.5, 155.0),
  (2.5, 145.0),
  (72.5, 5.0),
  (77.5, 5.0),
  (147.5, 145.0),
  (147.5, 155.0),
  (77.5, 295.0),
  (72.5, 295.0)
]

let kLEdges = [
  (0.0, 150.0),
  (75.0, 0.0),
  (150.0, 150.0),
  (75.0, 300.0)
]

let kCCoordinates = [
  (132.5, 45.0),
  (132.5, 35.0),
  (147.5, 5.0),
  (152.5, 5.0),
  (217.5, 145.0),
  (217.5, 155.0),
  (152.5, 295.0),
  (147.5, 295.0),
  (132.5, 265.0),
  (132.5, 255.0),
  (180.0, 155.0),
  (180.0, 145.0)
]

let kCEdges = [
  (130.0, 40.0),
  (150.0, 0.0),
  (220.0, 150.0),
  (150.0, 300.0),
  (130.0, 260.0),
  (182.5, 150.0)
]

let kRCoordinates = [
  (207.5, 45.0),
  (207.5, 35.0),
  (222.5, 5.0),
  (227.5, 5.0),
  (292.5, 145.0),
  (292.5, 155.0),
  (227.5, 295.0),
  (222.5, 295.0),
  (207.5, 265.0),
  (207.5, 255.0),
  (255.0, 155.0),
  (255.0, 145.0)
]

let kREdges = [
  (205.0, 40.0),
  (225.0, 0.0),
  (295.0, 150.0),
  (225.0, 300.0),
  (205.0, 260.0),
  (257.5, 150.0)
]

infix operator *** { associativity left precedence 1 }
func *** (left: [(Double, Double)], right: CGRect) -> [CGPoint] {
  return map(left){ (p) -> CGPoint in
    let origin = right.origin
    let (x, y) = p

    return CGPointMake(
      (CGFloat(x) + origin.x) * right.width / 300,
      (CGFloat(y) + origin.y) * right.height / 300
    )
  }
}

class TRLoaderView: UIView {

  private let gradient = CAGradientLayer()

  private var lpoints: [CGPoint] {
    get {
      return kLCoordinates *** bounds
    }
  }

  private var ledges: [CGPoint] {
    get {
      return kLEdges *** bounds
    }
  }

  private var cpoints: [CGPoint] {
    get {
      return kCCoordinates *** bounds
    }
  }

  private var cedges: [CGPoint] {
    get {
      return kCEdges *** bounds
    }
  }

  private var rpoints: [CGPoint] {
    get {
      return kRCoordinates *** bounds
    }
  }

  private var redges: [CGPoint] {
    get {
      return kREdges *** bounds
    }
  }

  var loading: Bool = false {
    didSet {
      if loading {
        let duration = 0.5
        let colors = [
          Colors.ZendeskGreen.CGColor,
          Colors.ZendeskGreen.CGColor,
          Colors.Kermit.CGColor,
          Colors.Kermit.CGColor,
          Colors.Forest.CGColor,
          Colors.Forest.CGColor,
          Colors.Kermit.CGColor,
          Colors.Kermit.CGColor,
        ]

        let len = countElements(colors)
        var frameColors = map(enumerate(colors)){(index, c) -> [CGColor!] in
          if index == 0 {
            return colors
          } else {
            var start = Array(colors[len - index - 1...len - 1])
            return start + Array(colors[0...len - index])
          }
        }

        let animation = CAKeyframeAnimation(keyPath: "colors")
        animation.values = frameColors
        animation.calculationMode = kCAAnimationPaced
        animation.duration = 1.0;
        animation.repeatCount = Float.infinity

        gradient.addAnimation(animation, forKey: "loader")
      } else {
        gradient.removeAnimationForKey("loader")
      }
    }
  }

  override init() {
    super.init()
    style()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    style()
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
    style()
  }

  func style() {
    let mask = CAShapeLayer()
    var sublayer = CAShapeLayer()
    var path = UIBezierPath()

    mask.frame = bounds
    gradient.frame = bounds
    gradient.colors = [
      Colors.ZendeskGreen.CGColor,
      Colors.ZendeskGreen.CGColor,
      Colors.Kermit.CGColor,
      Colors.Kermit.CGColor,
      Colors.Forest.CGColor,
      Colors.Forest.CGColor,
      Colors.Kermit.CGColor,
      Colors.Kermit.CGColor,
    ]
    gradient.locations = [0.0, 0.33, 0.5, 0.67, 1.0, 1.0, 1.0, 1.0]
    gradient.startPoint = CGPointMake(0, 0.5)
    gradient.endPoint = CGPointMake(1, 0.5)
    layer.insertSublayer(gradient, atIndex: 0)

    var lastPoint = lpoints[0]

    path.moveToPoint(lastPoint)

    for (index, point) in enumerate(lpoints) {
      if index % 2 != 0 {
        path.addQuadCurveToPoint(point, controlPoint: ledges[(index - 1) / 2])
      } else {
        path.addLineToPoint(point)
      }

      lastPoint = point
    }

    path.closePath()

    path.moveToPoint(cpoints[0])
    for (index, point) in enumerate(cpoints) {
      if index % 2 != 0 {
        path.addQuadCurveToPoint(point, controlPoint: cedges[(index - 1) / 2])
      } else {
        path.addLineToPoint(point)
      }
    }

    path.closePath()

    path.moveToPoint(rpoints[0])
    for (index, point) in enumerate(rpoints) {
      if index % 2 != 0 {
        path.addQuadCurveToPoint(point, controlPoint: redges[(index - 1) / 2])
      } else {
        path.addLineToPoint(point)
      }
    }

    path.closePath()

    sublayer.path = path.CGPath
    sublayer.fillColor = UIColor(red: 120/255, green: 163/255, blue: 0, alpha: 1.0).CGColor

    mask.addSublayer(sublayer)

    layer.mask = mask
  }
}