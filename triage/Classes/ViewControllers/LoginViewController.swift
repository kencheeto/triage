//
//  LoginViewController.swift
//  
//
//  Created by Christopher Kintner on 3/4/15.
//
//

import UIKit

class TriageButton: UIButton {

  override func awakeFromNib() {
    super.awakeFromNib()

    backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
    layer.borderColor = Colors.Kermit.CGColor
    layer.borderWidth = 2.0
    setTitleColor(Colors.Forest, forState: .Normal)
    setTitleColor(Colors.Forest, forState: .Selected)
    titleLabel!.font = UIFont(name: "ProximaNova-Semibold", size: 18.0)
    layer.cornerRadius = 4.0

    addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[self(42)]",
        options: nil,
        metrics: nil,
        views: ["self": self]
      )
    )
  }
}

class TriageTextField: UITextField {

  lazy private var bottomBorder = UIView()

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

  @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
  @IBOutlet weak var logo: UIImageView!
  @IBOutlet weak var background: UIImageView!

  @IBOutlet weak var emailInput: TriageTextField!
  @IBOutlet weak var passwordInput: TriageTextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    emailInput.delegate = self
    passwordInput.delegate = self

    emailInput.autocorrectionType = .No
    passwordInput.autocorrectionType = .No
    passwordInput.secureTextEntry = true
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

  @IBAction func onSignIn(sender: UIButton) {
    onSignIn()
  }

  func onSignIn() {
    API.authenticateUsingOAuthWithURLString(
      "oauth/tokens",
      username: emailInput.text,
      password: passwordInput.text,
      scope: "read write",
      success: didSignIn,
      failure: didFail
    )
  }

  func didSignIn(credential: AFOAuthCredential!) {
    AFOAuthCredential.storeCredential(credential, withIdentifier: APICredentialID)
    API.requestSerializer.setAuthorizationHeaderFieldWithCredential(credential)
    API.getMe(
      success: { (operation: AFHTTPRequestOperation!, user: UserFields) -> Void in
        UserFields.currentUser = user

        self.performSegueWithIdentifier("loginSegue", sender: self)
      },
      failure: nil
    )
  }

  func didFail(error: NSError!) {
    println(error)
  }
}

extension LoginViewController: UITextFieldDelegate {

  func textField(textField: UITextField, shouldChangeCharactersInRange
    range: NSRange, replacementString string: String) -> Bool {
    if textField != emailInput {
      return true
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

      return false
    }

    return true
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if countElements(emailInput.text) > 1 &&
      countElements(passwordInput.text) > 1 {
      textField.resignFirstResponder()

      onSignIn()

      return true
    }

    return false
  }
}