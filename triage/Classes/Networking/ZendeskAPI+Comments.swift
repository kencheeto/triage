//
//  ZendeskAPI+Comments.swift
//  triage
//
//  Created by Kurt Ruppel on 3/8/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

extension ZendeskAPI {
  

  final func getTicketComments(ticket_id: Int, success: ((operation: AFHTTPRequestOperation, response: AnyObject!) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
      let params = ["include": "users"]
      
      GET("/api/v2/tickets/\(ticket_id)/comments.json?include=users",
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
  
  final func getTicketComments(ticket_id: Int, success: ((operation: AFHTTPRequestOperation!, comments: [Comment]) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
      getTicketComments(ticket_id,
        success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
          let json = JSON.parse <^> response
          let structs: [CommentFields]? = json >>- { $0 <| "comments" >>- decodeArray }
          let comments = structs!.map({Comment(fields: $0)})
          
          _ = success?(operation: operation, comments: comments)
        },
        failure: failure
      )
  }
}
