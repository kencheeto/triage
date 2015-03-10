//
//  DetailsViewController.swift
//  triage
//
//  Created by Yeu-Shuan Tang on 3/9/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var ticket: Ticket!
    
    private var isPresenting: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(sender: UIButton) {
        self.transitioningDelegate = self
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationVC = segue.destinationViewController as UIViewController

        destinationVC.transitioningDelegate = self
    }
    

}

extension DetailViewController: UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate{
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let duration = self.transitionDuration(transitionContext)
        
        if isPresenting! {
            println("addView")
            container.addSubview(toView.view)
            toView.view.transform = CGAffineTransformMakeScale(1, 0)
            UIView.animateWithDuration(duration, animations: { () -> Void in
                toView.view.transform = CGAffineTransformMakeScale(1, 1)
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
            }
        } else{
            container.addSubview(fromView.view)
            fromView.view.transform = CGAffineTransformMakeScale(1, 1)
            UIView.animateWithDuration(duration, animations: { () -> Void in
                fromView.view.transform = CGAffineTransformMakeScale(1, 0.00001)
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromView.view.removeFromSuperview()
            }
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
}


