//
//  TicketFilterRow.swift
//  triage
//
//  Created by Kurt Ruppel on 3/8/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

struct TicketFilterRowFields {
  let requester_id: Int
  let ticket: Ticket
}

extension TicketFilterRowFields: JSONDecodable {

  static func create(requester_id: Int)(ticket: Ticket) -> TicketFilterRowFields {
    return TicketFilterRowFields(
      requester_id: requester_id,
      ticket: ticket
    )
  }

  static func decode(json: JSON) -> TicketFilterRowFields? {
    return TicketFilterRowFields.create
      <^> json <| "requester_id"
      <*> json <| "ticket"
  }
}

class TicketFilterRow {
  var fields: TicketFilterRowFields
  
  var requester_id: Int {
    get {
      return fields.requester_id
    }
  }
  
  var ticket: Ticket {
    get {
      return fields.ticket
    }
  }
  
  init(fields: TicketFilterRowFields) {
    self.fields = fields
  }
}