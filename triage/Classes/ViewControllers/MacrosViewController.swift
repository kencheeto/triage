//
//  MacrosViewController.swift
//  triage
//
//  Created by Kurt Ruppel on 3/8/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

class MacrosViewController: UIViewController {

  var macros: [Macro] = []

  private var isPresenting: Bool = false

  @IBOutlet weak var macrosTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
  }

  @IBAction func didTap(sender: UITapGestureRecognizer) {
    let height = macrosTableView.bounds.height
    let width = macrosTableView.bounds.width
    let point = sender.locationInView(macrosTableView)
    let x = point.x
    let y = point.y

    if (x > width || x < 0 || y > height || y < 0) {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    var destinationVC = segue.destinationViewController as UIViewController

    destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
    destinationVC.transitioningDelegate = self
  }
}

extension MacrosViewController: UIViewControllerTransitioningDelegate {
}

extension MacrosViewController: UIViewControllerAnimatedTransitioning {

  func animationControllerForPresentedController(presented: UIViewController!,
    presentingController presenting: UIViewController!,
    sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
    isPresenting = true

    return self
  }

  func animationControllerForDismissedController(dismissed: UIViewController!) ->
    UIViewControllerAnimatedTransitioning! {
    isPresenting = false

    return self
  }

  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 0.4
  }

  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView()
    let toViewController = transitionContext.viewControllerForKey(
      UITransitionContextToViewControllerKey
    )!
    let fromViewController = transitionContext.viewControllerForKey(
      UITransitionContextFromViewControllerKey
    )!

    if (isPresenting) {
      containerView.addSubview(toViewController.view)
      toViewController.view.alpha = 0
      UIView.animateWithDuration(0.4, animations: { () -> Void in
        toViewController.view.alpha = 1
        }) { (finished: Bool) -> Void in
          transitionContext.completeTransition(true)
      }
    } else {
      UIView.animateWithDuration(0.4, animations: { () -> Void in
        fromViewController.view.alpha = 0
        }) { (finished: Bool) -> Void in
          transitionContext.completeTransition(true)
          fromViewController.view.removeFromSuperview()
      }
    }
  }
}