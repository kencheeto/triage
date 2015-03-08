//
//  ZendeskAPI+Tickets.swift
//  triage
//
//  Created by Kurt Ruppel on 3/8/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

extension ZendeskAPI {

  final func updateTicket(id: Int, parameters: NSDictionary,
    success: ((operation: AFHTTPRequestOperation, response: AnyObject!) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    PUT("api/v2/tickets/\(id)",
      parameters: ["ticket": parameters],
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

  final func updateTicket(ticket: Ticket,
    success: ((operation: AFHTTPRequestOperation, response: AnyObject!) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
      println(Ticket.toDictionary(ticket) as NSDictionary)
    updateTicket(
      ticket.id,
      parameters: Ticket.toDictionary(ticket) as NSDictionary,
      success: success,
      failure: failure
    )
  }
}
