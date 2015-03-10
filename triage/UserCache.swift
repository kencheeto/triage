//
//  UserCache.swift
//  triage
//
//  Created by Christopher Kintner on 3/9/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import Foundation

class UserCache {
  private var cache: NSCache
  
  init() {
    cache = NSCache()
  }
  
  func lookupUserByUserId(user_id: Int) -> (User?) {
    return cache.objectForKey(cacheKey(user_id)) as? User
  }
  
  func setUserByUserId(user_id: Int, user: User) {
    cache.setObject(user, forKey: cacheKey(user_id))
  }
  
  private func cacheKey(user_id: Int) -> (String) {
    return "user:\(user_id)"
  }
  
}
