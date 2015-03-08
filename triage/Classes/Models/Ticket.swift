//
//  Ticket.swift
//  triage
//
//  Created by Kurt Ruppel on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

struct Ticket {
  let id: Int
  var subject: String
  let description: String
  var status: String?
  var priority: String?
}

extension Ticket: JSONDecodable, JSONSerializable {

  static func create(id: Int)
    (subject: String)
    (description: String)
    (status: String?)
    (priority: String?) -> Ticket {
    return Ticket(
      id: id,
      subject: subject,
      description: description,
      status: status,
      priority: priority
    )
  }

  static func decode(json: JSON) -> Ticket? {
    return Ticket.create
      <^> json <| "id"
      <*> json <| "subject"
      <*> json <| "description"
      <*> json <|? "status"
      <*> json <|? "priority"
  }

  static func toDictionary(ticket: Ticket) -> NSDictionary {
    return [
      "id": ticket.id,
      "subject": ticket.subject,
      "description": ticket.description,
      "status": ticket.status ?? NSNull(),
      "priority": ticket.priority ?? NSNull()
    ]
  }
}
