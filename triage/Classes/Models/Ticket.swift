//
//  Ticket.swift
//  triage
//
//  Created by Kurt Ruppel on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

struct Ticket {
  let id: Int
  let subject: String
  let description: String
  let status: String?
  let priority: String?
}

extension Ticket: JSONDecodable {

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
}
