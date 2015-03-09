//
//  TicketFilter.swift
//  triage
//
//  Created by Kurt Ruppel on 3/8/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

struct TicketFilter {
  let id: Int
}

extension TicketFilter: JSONDecodable {

  static func create(id: Int) -> TicketFilter {
    return TicketFilter(
      id: id
    )
  }

  static func decode(json: JSON) -> TicketFilter? {
    return TicketFilter.create
      <^> json <| "id"
  }
}
