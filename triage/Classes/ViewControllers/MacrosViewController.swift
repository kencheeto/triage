//
//  MacrosViewController.swift
//  triage
//
//  Created by Kurt Ruppel on 3/8/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

class MacrosViewController: UIViewController {

  private let API = ZendeskAPI.instance
  private let notificationCenter: NSNotificationCenter =
    NSNotificationCenter.defaultCenter()

  var macros: [Macro] = []
  var cell: TicketTableViewCell?
  var ticketsViewController: TicketsViewController?

  private var isPresenting: Bool = false

  @IBOutlet weak var macrosTableView: UITableView!
  @IBOutlet weak var macrosTableViewHeader: MacrosTableHeaderView!

  @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)

    macrosTableView.delegate = self
    macrosTableView.dataSource = self
    macrosTableView.rowHeight = UITableViewAutomaticDimension
    macrosTableView.scrollEnabled = false
    macrosTableView.layer.cornerRadius = 5.0
    macrosTableView.layoutMargins = UIEdgeInsetsZero
    macrosTableView.separatorInset = UIEdgeInsetsZero
    macrosTableView.tableHeaderView = macrosTableViewHeader

    tapGestureRecognizer.delegate = self

    notificationCenter.addObserver(
      self,
      selector: "didCloseMacros:",
      name: "macros:close",
      object: nil
    )
  }

  @IBAction func didTap(sender: UITapGestureRecognizer) {
    let height = macrosTableView.bounds.height
    let width = macrosTableView.bounds.width
    let point = sender.locationInView(macrosTableView)
    let x = point.x
    let y = point.y

    if (x > width || x < 0 || y > height || y < 0) {
      closeWithoutAction()
    }
  }

  func didCloseMacros(notification: NSNotification) {
    closeWithoutAction()
  }

  func closeWithAction(macro: Macro) {
    var ticketsTableView = ticketsViewController!.ticketsTableView
    let rows = ticketsViewController!.rows
    let cell = self.cell!
    var indexPath = ticketsTableView.indexPathForCell(cell)

    dismissViewControllerAnimated(true, completion: nil)
    cell.swipeView.removeFromSuperview()
    ticketsViewController!.removeAtIndex(indexPath!)
    ticketsTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Right)
    UIView.animateWithDuration(0.2, animations: {
      }, completion: { (completed) -> Void in
      cell.frame = CGRectMake(0, cell.bounds.origin.y, UIScreen.mainScreen().bounds.width, cell.bounds.height)
      cell.ticketView.center.x = cell.frame.width / 2
    })

    API.applyMacroToTicket(macro, ticket: cell.ticket!, success: { (operation, result) -> Void in
      result.ticket.save(success: nil, failure: nil)
    }) { (operation, error) -> Void in
      //
    }
  }

  func closeWithoutAction() {
    dismissViewControllerAnimated(true, completion: nil)

    let cell = self.cell!
    UIView.animateWithDuration(0.2, animations: {
      cell.center.x = (cell.frame.width / 2) - cell.swipeView.frame.width
      }, completion: { (completed) -> Void in
        cell.swipeView.removeFromSuperview()
        cell.frame = CGRectMake(0, cell.frame.origin.y, UIScreen.mainScreen().bounds.width, cell.bounds.height)
        cell.ticketView.center.x = cell.center.x
    })
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    var destinationVC = segue.destinationViewController as UIViewController

    destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
    destinationVC.transitioningDelegate = self
  }
}

extension MacrosViewController: UITableViewDataSource {

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = macrosTableView.dequeueReusableCellWithIdentifier(
      "MacrosTableViewCell", forIndexPath: indexPath
    ) as MacrosTableViewCell
    let macro = macros[indexPath.row]
    let height = cell.frame.origin.y + cell.bounds.height

    macrosTableView.frame = CGRectMake(
      macrosTableView.frame.origin.x,
      (UIScreen.mainScreen().bounds.height / 2) - (height / 2),
      cell.bounds.width,
      height
    )
    cell.layoutMargins = UIEdgeInsetsZero
    cell.macro = macro

    if indexPath.row == macros.count - 1 {
      cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, tableView.bounds.width)
    }

    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return macros.count
  }
}

extension MacrosViewController: UITableViewDelegate  {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    closeWithAction(macros[indexPath.row])
  }
}

extension MacrosViewController: UIGestureRecognizerDelegate {
  override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    return !touch.view.isDescendantOfView(macrosTableView)
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
      self.macrosTableView.transform = CGAffineTransformMakeScale(0.1, 0.1)
      UIView.animateWithDuration(0.2, animations: { () -> Void in
        toViewController.view.alpha = 1
        self.macrosTableView.transform = CGAffineTransformMakeScale(1, 1)
        }) { (finished: Bool) -> Void in
          transitionContext.completeTransition(true)
      }
    } else {
      UIView.animateWithDuration(0.1, animations: { () -> Void in
        fromViewController.view.alpha = 0
        self.macrosTableView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) { (finished: Bool) -> Void in
          transitionContext.completeTransition(true)
          fromViewController.view.removeFromSuperview()
      }
    }
  }
}