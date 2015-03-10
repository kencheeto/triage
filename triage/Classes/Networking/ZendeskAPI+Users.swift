//
//  ZendeskAPI+Views.swift
//  triage
//
//  Created by Kurt Ruppel on 3/7/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

extension ZendeskAPI {

  final func getMe(#success: ((operation: AFHTTPRequestOperation, response: AnyObject!) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    GET("api/v2/users/me",
      parameters: nil,
      success: { (operation: AFHTTPRequestOperation!,
        response: AnyObject!) -> Void in
        _ = success?(operation: operation, response: response!)
      },
      failure: { (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void in
        _ = failure?(operation: operation, error: error)
      }
    )
  }

  final func getMe(#success: ((operation: AFHTTPRequestOperation!, user: UserFields) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    getMe(
      success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        let json = JSON.parse <^> response
        let user: UserFields? = json >>- { $0 <| "user" >>- UserFields.decode }

        _ = success?(operation: operation, user: user!)
      },
      failure: failure
    )
  }
  
  final func getManyUsers(user_ids: [Int], success: ((operation: AFHTTPRequestOperation, response: AnyObject!) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
      let ids = ",".join(user_ids.map {String($0)})
      let params = ["ids": ids]
      
      GET("api/v2/users/show_many",
        parameters: params,
        success: { (operation: AFHTTPRequestOperation!,
          response: AnyObject!) -> Void in
          _ = success?(operation: operation, response: response!)
        },
        failure: { (operation: AFHTTPRequestOperation!,
          error: NSError!) -> Void in
          _ = failure?(operation: operation, error: error)
        }
      )
  }
  
  
  final func getManyUsers(user_ids: [Int], success: ((operation: AFHTTPRequestOperation!, users: [User]) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
      getManyUsers(user_ids,
        success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
          let json = JSON.parse <^> response
          let structs: [UserFields]? = json >>- { $0 <| "users" >>- decodeArray }
          let users = structs!.map({User(fields: $0)})
          
          _ = success?(operation: operation, users: users)
        },
        failure: failure
      )
  }
}