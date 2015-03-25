//
//  LoginViewController.swift
//  
//
//  Created by Christopher Kintner on 3/4/15.
//
//

import UIKit

class TriageButton: UIButton {

  var buttonHeight: Float = 42.0
  var buttonFontSize: Float = 18.0

  override var enabled: Bool {
    didSet {
      var color = enabled ? Colors.Forest : Colors.Iron

      self.setTitleColor(color, forState: .allZeros)
      self.layer.borderColor = color.CGColor
    }
  }

  override init() {
    super.init()
    applyStyle()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  convenience init(height: Float, fontSize: Float) {
    self.init()

    buttonHeight = height
    buttonFontSize = fontSize

    titleLabel!.font = UIFont(name: "ProximaNova-Semibold", size: CGFloat(buttonFontSize))
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    applyStyle()
  }

  func applyStyle() {
    backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
    layer.borderWidth = 2.0
    setTitleColor(Colors.Forest, forState: .Normal)
    setTitleColor(Colors.Forest, forState: .Selected)
    setTitleColor(Colors.Aluminum, forState: .Disabled)
    titleLabel!.font = UIFont(name: "ProximaNova-Semibold", size: CGFloat(buttonFontSize))
    layer.cornerRadius = 4.0

    if !translatesAutoresizingMaskIntoConstraints() {
      addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat(
          "V:[self(\(buttonHeight))]",
          options: nil,
          metrics: nil,
          views: ["self": self]
        )
      )
    }
  }
}

class TriageTextField: UITextField {

  lazy private var bottomBorder = UIView()

  override var enabled: Bool {
    didSet {
      alpha = enabled ? 1 : 0.7
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    bottomBorder.setTranslatesAutoresizingMaskIntoConstraints(false)
    bottomBorder.backgroundColor = Colors.Gainsboro

    addSubview(bottomBorder)

    font = UIFont(name: "ProximaNova-Regular", size: 18.0)

    addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[self(35)]",
        options: nil,
        metrics: nil,
        views: ["self": self]
      )
    )
    addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[border(1)]|",
        options: nil,
        metrics: nil,
        views: ["border": bottomBorder]
      )
    )
    addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[border]|",
        options: nil,
        metrics: nil,
        views: ["border": bottomBorder]
      )
    )
  }
}

class LoginViewController: UIViewController {
  private let API = ZendeskAPI.instance
  private let kDomain = "zendesk.com"

  @IBOutlet weak var loaderView: TRLoaderView!
  @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
  @IBOutlet weak var logo: UIImageView!
  @IBOutlet weak var background: UIImageView!

  @IBOutlet weak var emailInput: TriageTextField!
  @IBOutlet weak var passwordInput: TriageTextField!
  @IBOutlet weak var signInButton: TriageButton!

  @IBOutlet weak var loaderViewXConstraint: NSLayoutConstraint!
  @IBOutlet weak var loaderViewYConstraint: NSLayoutConstraint!

  private var isPresenting = false

  private var isValid: Bool {
    get {
      return countElements(emailInput.text) > 0 &&
        countElements(passwordInput.text) > 0
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    loaderView.alpha = 0

    emailInput.delegate = self
    passwordInput.delegate = self

    emailInput.autocorrectionType = .No
    passwordInput.autocorrectionType = .No
    passwordInput.secureTextEntry = true

    signInButton.enabled = isValid
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    centerYConstraint.constant = 150.0
    UIView.animateWithDuration(
      0.2,
      delay: 0,
      options: .CurveEaseIn,
      animations: { () -> Void in
        self.background.alpha = 0.5
        self.view.layoutIfNeeded()
      },
      completion: { (done: Bool) -> Void in
        //
      }
    )
  }

  func signIn() {
    emailInput.enabled = false
    passwordInput.enabled = false

    signInButton.enabled = false
    signInButton.setTitle("Signing in...", forState: .allZeros)

    UIView.animateWithDuration(
      0.2,
      delay: 0,
      options: .CurveEaseIn,
      animations: { () -> Void in
        self.logo.alpha = 0
        self.loaderView.alpha = 1
      },
      completion: { (done: Bool) -> Void in
        self.loaderView.loading = true
        self.view.removeConstraint(self.loaderViewXConstraint)
        self.loaderViewXConstraint = NSLayoutConstraint(
          item: self.view,
          attribute: .CenterX,
          relatedBy: .Equal,
          toItem: self.loaderView,
          attribute: .CenterX,
          multiplier: 1.0,
          constant: 0
        )
        self.view.addConstraint(self.loaderViewXConstraint)
        UIView.animateWithDuration(
          0.2,
          delay: 0,
          options: .CurveEaseIn,
          animations: { () -> Void in
            self.view.layoutIfNeeded()
          },
          completion: { (done: Bool) -> Void in
            _ = self.API.authenticateUsingOAuthWithURLString(
              "oauth/tokens",
              username: self.emailInput.text,
              password: self.passwordInput.text,
              scope: "read write",
              success: self.didSignIn,
              failure: self.didFail
            )
          }
        )
      }
    )
  }

  @IBAction func onSignIn(sender: UIButton) {
    signIn()
  }

  func didSignIn(credential: AFOAuthCredential!) {
    AFOAuthCredential.storeCredential(credential, withIdentifier: APICredentialID)
    API.requestSerializer.setAuthorizationHeaderFieldWithCredential(credential)
    API.getMe(
      success: { (operation: AFHTTPRequestOperation!, user: UserFields) -> Void in
        UserFields.currentUser = user
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(
          "TicketsNavViewController"
        ) as TicketsNavigationController

        viewController.modalPresentationStyle = .Custom
        viewController.transitioningDelegate = self

        self.presentViewController(viewController, animated: true, completion: nil)
      },
      failure: nil
    )
  }

  func didFail(error: NSError!) {
    emailInput.enabled = true
    passwordInput.enabled = true

    signInButton.enabled = isValid
    signInButton.setTitle("Sign in", forState: .allZeros)

    self.view.removeConstraint(self.loaderViewXConstraint)
    self.loaderViewXConstraint = NSLayoutConstraint(
      item: self.logo,
      attribute: .Leading,
      relatedBy: .Equal,
      toItem: self.loaderView,
      attribute: .Leading,
      multiplier: 1.0,
      constant: 0
    )
    self.view.addConstraint(self.loaderViewXConstraint)
    UIView.animateWithDuration(
      0.2,
      delay: 0,
      options: .CurveEaseIn,
      animations: { () -> Void in
        self.signInButton.layer.borderColor = Colors.DarkPastelRed.CGColor
        self.signInButton.setTitleColor(Colors.DarkPastelRed, forState: .allZeros)
        self.view.layoutIfNeeded()
      },
      completion: { (done: Bool) -> Void in
        let wiggle = CABasicAnimation(keyPath: "position")

        wiggle.duration = 0.1
        wiggle.repeatCount = 2
        wiggle.autoreverses = true
        wiggle.removedOnCompletion = true
        wiggle.fromValue = NSValue(CGPoint: CGPointMake(self.signInButton.center.x - 3, self.signInButton.center.y))
        wiggle.toValue = NSValue(CGPoint: CGPointMake(self.signInButton.center.x + 3, self.signInButton.center.y))
        self.signInButton.layer.addAnimation(wiggle, forKey: "wiggle")
        self.signInButton.setTitle("Sign in failed", forState: .allZeros)

        _ = UIView.animateWithDuration(
          0.2,
          animations: { () -> Void in
            self.logo.alpha = 1
            self.loaderView.alpha = 0
          }
        )
      }
    )
  }
}

extension LoginViewController: UITextFieldDelegate {

  func textField(textField: UITextField, shouldChangeCharactersInRange
    range: NSRange, replacementString string: String) -> Bool {
    signInButton.setTitle("Sign in", forState: .allZeros)

    if textField != emailInput {
      let text = passwordInput.text as NSString
      passwordInput.text = text.stringByReplacingCharactersInRange(
        range,
        withString: string
      )
      signInButton.enabled = isValid

      return false
    }

    var str = (emailInput.text as NSString).stringByReplacingCharactersInRange(
      range,
      withString: string
    )

    if countElements(textField.text) == 0 && countElements(str) > 0 {
      let domain = NSMutableAttributedString(string: "@\(kDomain)")
      domain.addAttribute(
        NSForegroundColorAttributeName,
        value: Colors.DarkGray,
        range: NSMakeRange(0, countElements(kDomain) + 1)
      )

      let text = NSMutableAttributedString(string: str)
      text.appendAttributedString(domain)
      textField.attributedText = text

      let selectedRange = textField.selectedTextRange!
      let newPosition = textField.positionFromPosition(
        selectedRange.start as UITextPosition!,
        offset: -(text.length - 1)
      )
      let newRange = textField.textRangeFromPosition(
        newPosition,
        toPosition: newPosition
      )

      textField.selectedTextRange = newRange
      signInButton.enabled = isValid

      return false
    }

    signInButton.enabled = isValid

    return true
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if isValid {
      textField.resignFirstResponder()
      signIn()

      return true
    }

    return false
  }
}

extension LoginViewController: UIViewControllerTransitioningDelegate,
  UIViewControllerAnimatedTransitioning {

  func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
    isPresenting = true

    return self
  }

  func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
    isPresenting = false

    return self
  }

  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 0.4
  }

  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView()
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!

    if (isPresenting) {
      containerView.addSubview(toViewController.view)
      toViewController.view.alpha = 0

      view.removeConstraint(loaderViewYConstraint)
      view.addConstraint(
        NSLayoutConstraint(
          item: self.view,
          attribute: .Top,
          relatedBy: .Equal,
          toItem: self.loaderView,
          attribute: .TopMargin,
          multiplier: 1.0,
          constant: -30
        )
      )
      loaderView.transform = CGAffineTransformMakeScale(
        25 / loaderView.bounds.width,
        25 / loaderView.bounds.height
      )
      UIView.animateWithDuration(
        0.2,
        animations: { () -> Void in
          self.background.alpha = 0
          self.emailInput.alpha = 0
          self.passwordInput.alpha = 0
          self.signInButton.alpha = 0
          self.view.layoutIfNeeded()
        },
        completion: { (done: Bool) -> Void in
          _ = UIView.animateWithDuration(
            0.2,
            animations: { () -> Void in
              toViewController.view.alpha = 1
            },
            completion: { (done: Bool) -> Void in
              transitionContext.completeTransition(true)
            }
          )
        }
      )
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