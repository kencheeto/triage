//
//  UserCache.swift
//  triage
//
//  Created by Christopher Kintner on 3/9/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import Foundation

class UserCache {
  struct Static {
    static private var cache = NSCache()
  }
  
  class func lookupUserByUserId(user_id: Int) -> (User?) {
    return Static.cache.objectForKey(cacheKey(user_id)) as? User
  }
  
  class func setUserByUserId(user_id: Int, user: User) {
//    Static.cache.setObject(user, forKey: cacheKey(user_id))
  }
  
  class private func cacheKey(user_id: Int) -> (String) {
    return "user:\(user_id)"
  }
  
}