//
//  ZendeskAPI+Views.swift
//  triage
//
//  Created by Kurt Ruppel on 3/7/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

extension ZendeskAPI {

  func getMe(#success: ((operation: AFHTTPRequestOperation!, response: AnyObject) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    GET("api/v2/users/me",
      parameters: nil,
      success: { (operation: AFHTTPRequestOperation!,
        response: AnyObject!) -> Void in
        _ = success?(operation: operation, response: response)
      },
      failure: { (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void in
        _ = failure?(operation: operation, error: error)
      }
    )
  }
}