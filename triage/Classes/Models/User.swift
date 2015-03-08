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
  var name: String?
  var email: String?
  
  override func updateFromDict(dict: NSDictionary) {
    dictionary = dict
    name = dict["name"] as? String
    id = dict["id"] as? Int
    email = dict["email"] as? String
  }
  
  override class func resourceUrl(id: Int) -> String {
    return "/api/v2/users/\(id).json"
  }
  
  override class func resourceName() -> String {
    return "user"
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
  
  class func loadCurrentUser(completion: (user: User?, error: NSError?) -> ()) {
    ZendeskAPI.instance.GET("/api/v2/users/me.json", parameters: nil, success: { (task: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        var hash = response as NSDictionary
        var userDict = hash.valueForKey("user") as NSDictionary
        var user = User(dict: userDict)
      
        NSLog("user: %@", response as NSDictionary)
        User.currentUser = user
        completion(user: user, error: nil)
      }, failure: nil)
    
  }
  

}
