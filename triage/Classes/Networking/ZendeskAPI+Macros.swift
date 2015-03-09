//
//  ZendeskAPI+Macros.swift
//  triage
//
//  Created by Kurt Ruppel on 3/8/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

extension ZendeskAPI {

  final func getMacros(#success: ((operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    GET("api/v2/macros",
      parameters: [],
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

  final func getMacros(#success: ((operation: AFHTTPRequestOperation!, macros: [Macro]) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    getMacros(
      success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        let json = JSON.parse <^> response
        let macros: [Macro]? = json >>- { $0 <| "macros" >>- decodeArray }

        _ = success?(operation: operation, macros: macros!)
      },
      failure: failure
    )
  }

  final func applyMacroToTicket(macroID: Int, ticketID: Int,
    success: ((operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    GET("api/v2/tickets/\(ticketID)/macros/\(macroID)/apply",
      parameters: [],
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

  final func applyMacroToTicket(macroID: Int, ticketID: Int,
    success: ((operation: AFHTTPRequestOperation!, result: MacroResult) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    GET("api/v2/tickets/\(ticketID)/macros/\(macroID)/apply",
      parameters: [],
      success: { (operation: AFHTTPRequestOperation!,
        response: AnyObject!) -> Void in
        let json = JSON.parse <^> response
        let result: MacroResult? = json >>- { $0 <| "result" >>- MacroResult.decode }

        _ = success?(operation: operation, result: result!)
      },
      failure: { (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void in
        _ = failure?(operation: operation, error: error)
      }
    )
  }

  final func applyMacroToTicket(macro: Macro, ticket: Ticket,
    success: ((operation: AFHTTPRequestOperation!, result: MacroResult) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) {
    applyMacroToTicket(
      macro.id,
      ticketID: ticket.id,
      success: success,
      failure: failure
    )
  }
}
