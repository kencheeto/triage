//
//  LoginViewController.swift
//  
//
//  Created by Christopher Kintner on 3/4/15.
//
//

import UIKit

class LoginViewController: UIViewController {
  private let API = ZendeskAPI.instance

  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  @IBAction func loginTapped(sender: UIButton) {
    API.authenticateUsingOAuthWithURLString(
      "oauth/tokens",
      username: emailField.text,
      password: passwordField.text,
      scope: "read write",
      success: didLogin,
      failure: didFail
    )
  }

  func didLogin(credential: AFOAuthCredential!) {
    AFOAuthCredential.storeCredential(credential, withIdentifier: APICredentialID)
    API.requestSerializer.setAuthorizationHeaderFieldWithCredential(credential)
    API.getMe(
      success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        println(response)
//        User.currentUser = User.create(JSON(response))
        self.performSegueWithIdentifier("loginSegue", sender: self)
      },
      failure: nil
    )
  }

  func didFail(error: NSError!) {
    println(error)
  }
}