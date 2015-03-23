//
//  User.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import Foundation
private let defaults = NSUserDefaults.standardUserDefaults()
private let API = ZendeskAPI.instance

private var _currentUser: UserFields?
private var _currentUserData: NSDictionary?

struct UserFields {

  let id: Int
  let name: String
  let email: String
}

extension UserFields: JSONDecodable, JSONSerializable {

  static func create(id: Int)(name: String)(email: String) -> UserFields {
    return UserFields(
      id: id,
      name: name,
      email: email
    )
  }

  static func decode(json: JSON) -> UserFields? {
    return UserFields.create
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

  static var currentUser: UserFields? {
    get {
      if _currentUser == nil && currentUserData != nil {
        let json = JSON.parse <^> _currentUserData
        _currentUser = UserFields.decode(json!)
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
        success: { (operation: AFHTTPRequestOperation!, user: UserFields!) -> Void in
          self.currentUser = user
        },
        failure: nil
      )
    })
  }
}

let AVATAR_GENERATOR_DOMAIN = "http://triage-avatars.herokuapp.com"

class User {
  var fields: UserFields

  var emailHash: String {
    get {
      return fields.email.lowercaseString.md5
    }
  }

  var defaultAvatarURL: String {
    get {
      let hashValue = emailHash.hashValue
      var value = (hashValue << 8) % 121

      if (value < 60) {
        value = 121 - value
      }

      let green = NSString(format: "%02X", value & 0xFF)
      let hexString = "50\(green)30"
      let name = fields.name.stringByReplacingOccurrencesOfString(" ", withString: "_")

      return "\(AVATAR_GENERATOR_DOMAIN)/180x180/\(hexString)/FBFBFB/\(name)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }
  }
  
  init(fields: UserFields) {
    self.fields = fields
  }

  func avatarURL() -> (String) {
    return "http://gravatar.com/avatar/\(emailHash)?d=\(defaultAvatarURL)&s=64&r=g"
  }
}
