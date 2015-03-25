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
        let rowsFields: [TicketFilterRowFields]? = json >>- { $0 <| "rows" >>- decodeArray }
        let rows = rowsFields!.map({TicketFilterRow(fields: $0)})
        self.loadRequesters(rows, success: success, failure: failure)

      },
      failure: { (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void in
        _ = failure?(operation: operation, error: error)
      }
    )
  }


  func loadRequesters(rows: [TicketFilterRow],
    success: ((operation: AFHTTPRequestOperation!, rows: [TicketFilterRow]) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    var ticketsNeedingRequester = [TicketFilterRow]()
    var userIdsToFetch = [Int: AnyObject]() // hash as set
    
    for ticketRow in rows {
      if ticketRow.ticket.requester == nil {
        if let cachedUser = UserCache.lookupUserByUserId(ticketRow.requester_id) {
          var ticket = ticketRow.fields.ticket
          ticket.requester = cachedUser
        } else {
          ticketsNeedingRequester.append(ticketRow)
          userIdsToFetch[ticketRow.requester_id] = 1
        }
      }
    }
    
    
    getManyUsers(userIdsToFetch.keys.array, success: { (operation: AFHTTPRequestOperation!, users: [User]) -> Void in
      
      for ticketRow in ticketsNeedingRequester {
        var match = users.filter({$0.fields.id == ticketRow.requester_id})
        if match.count > 0 {
          var fields = ticketRow.fields
          var ticket = fields.ticket
          ticket.requester = match[0]
          ticketRow.fields = TicketFilterRowFields(requester_id: fields.requester_id, ticket: ticket)
        }
      }
      
      success?(operation: operation, rows: rows)
      
      }, failure: failure)
  }

}
