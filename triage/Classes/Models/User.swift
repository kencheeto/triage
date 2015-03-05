//
//  User.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

var _currentUser: User?
var email: String?
var _password: String?
let currentUserKey = "triage_current_user_key"

class User: Resource {
  var dictionary: NSDictionary?
  var name: String?
  var id: Int?
  var email: String?
  var ouathToken: String?

  init(dict: NSDictionary) {
    dictionary = dict
    name = dict["name"] as? String
    id = dict["id"] as? Int
    email = dict["email"] as? String
    ouathToken = dict["oauthToken"] as? String
  }

  class var currentUser: User? {
    get {
      if _currentUser == nil {
        var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if data != nil {
          var dict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
          _currentUser = User(dict: dict)
        }
      }
      return _currentUser
    }
    
    set(user) {
      _currentUser = user
      if _currentUser != nil {
        var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: nil, error: nil);
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
      } else {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
      }
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  class func loginUser(email: String, password: String) {

    ApiClient.sharedInstance.getAccessToken(email, password: password) { (token) -> () in
      ApiClient.sharedInstance.setToken(token)
      self.loadCurrentUser()
    }
  }
  
  class func loadCurrentUser() {
    ApiClient.sharedInstance.GET("/api/v2/users/me.json", parameters: nil, success: { (task: NSURLSessionDataTask!, response: AnyObject!) -> Void in
        var user = User(dict: response as NSDictionary)
        NSLog("user: %@", response as NSDictionary)
        user.ouathToken = ApiClient.sharedInstance.accessToken
        User.currentUser = user
      }, failure: handleFailure)
    
  }
  
  class func handleFailure(task: NSURLSessionDataTask!, error: NSError!) {
    NSLog("Error %@", error)
  }
}
