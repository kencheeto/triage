//
//  ZendeskAPI+Views.swift
//  triage
//
//  Created by Kurt Ruppel on 3/7/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

extension ZendeskAPI {

  func getViews(#success: ((response: AnyObject) -> Void)?,
    failure: ((error: NSError) -> Void)?) {
    GET("api/v2/views",
      parameters: [],
      success: { (operation: AFHTTPRequestOperation!,
        response: AnyObject!) -> Void in
        _ = success?(response: response)
      },
      failure: { (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void in
        // Handle error
        _ = failure?(error: error)
      }
    )
  }

  func executeView(id: NSString, success: ((response: AnyObject) -> Void)?,
    failure: ((error: NSError) -> Void)?) {
  }
}
