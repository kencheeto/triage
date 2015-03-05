//
//  LoginViewController.swift
//  
//
//  Created by Christopher Kintner on 3/4/15.
//
//

import UIKit

class LoginViewController: UIViewController {
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  @IBAction func loginTapped(sender: UIButton) {
    User.loginUser(emailField.text, password: passwordField.text) { (user, error) -> () in
      if user != nil {
        self.performSegueWithIdentifier("loginSegue", sender: self)
      }
      
      self.handleError(error)
      
    }
  }
  
  
  func handleError(error: NSError?) {
    if error != nil {
      NSLog("error: %@", error!)
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
