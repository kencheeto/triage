//
//  ZendeskAPI+Views.swift
//  triage
//
//  Created by Kurt Ruppel on 3/7/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

extension ZendeskAPI {

  final func getViews(#success: ((operation: AFHTTPRequestOperation!, filters: [TicketFilter]) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    GET("api/v2/views",
      parameters: [],
      success: { (operation: AFHTTPRequestOperation!,
        response: AnyObject!) -> Void in
        let json = JSON.parse <^> response
        let filters: [TicketFilter]? = json >>- { $0 <| "views" >>- decodeArray }

        _ = success?(operation: operation, filters: filters!)
      },
      failure: { (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void in
        _ = failure?(operation: operation, error: error)
      }
    )
  }

  final func executeView(id: Int, parameters: NSDictionary,
    success: ((operation: AFHTTPRequestOperation!, rows: [TicketFilterRow]) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    GET("api/v2/views/\(id)/execute",
      parameters: parameters,
      success: { (operation: AFHTTPRequestOperation!,
        response: AnyObject!) -> Void in
        let json = JSON.parse <^> response
        let rows: [TicketFilterRow]? = json >>- { $0 <| "rows" >>- decodeArray }

        _ = success?(operation: operation, rows: rows!)
      },
      failure: { (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void in
        _ = failure?(operation: operation, error: error)
      }
    )
  }
}
