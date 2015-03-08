//
//  TicketFilterRow.swift
//  triage
//
//  Created by Kurt Ruppel on 3/8/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

struct TicketFilterRow {
  let ticket: Ticket
}

extension TicketFilterRow: JSONDecodable {

  static func create(ticket: Ticket) -> TicketFilterRow {
    return TicketFilterRow(
      ticket: ticket
    )
  }

  static func decode(json: JSON) -> TicketFilterRow? {
    return TicketFilterRow.create
      <*> json <| "ticket"
  }
}
