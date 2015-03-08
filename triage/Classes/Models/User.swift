//
//  User.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

private let defaults = NSUserDefaults.standardUserDefaults()
private let API = ZendeskAPI.instance

private var _currentUser: User?
private var _currentUserData: NSDictionary?

struct User {

  let id: Int
  let name: String
  let email: String
}

extension User: JSONDecodable, JSONSerializable {

  static func create(id: Int)(name: String)(email: String) -> User {
    return User(
      id: id,
      name: name,
      email: email
    )
  }

  static func decode(json: JSON) -> User? {
    return User.create
      <^> json <| "id"
      <*> json <| "name"
      <*> json <| "email"
  }

  func toDictionary() -> NSDictionary {
    return [
      "id": id,
      "name": name,
      "email": email
    ]
  }

  static var currentUser: User? {
    get {
      if _currentUser == nil && currentUserData != nil {
        let json = JSON.parse <^> _currentUserData
        _currentUser = User.decode(json!)
      }

      return _currentUser
    }

    set(user) {
      if user != nil {
        _currentUserData = user!.toDictionary() as? [String: AnyObject]
      }

      _currentUser = user
    }
  }

  static var currentUserData: NSDictionary? {
    get {
      if _currentUserData == nil {
        _currentUserData = defaults.objectForKey(kCurrentUserKey) as? NSDictionary
      }

      return _currentUserData
    }

    set(data) {
      defaults.setObject(data, forKey: kCurrentUserKey)
      _currentUserData = data
    }
  }

  static func refreshCurrentUser() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      API.getMe(
        success: { (operation: AFHTTPRequestOperation!, user: User!) -> Void in
          self.currentUser = user
        },
        failure: nil
      )
    })
  }
}
