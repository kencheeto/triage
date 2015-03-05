//
//  Ticket.swift
//  triage
//
//  Created by Kurt Ruppel on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

class Ticket {

  internal var data: JSON

  var subject: String

  init(json: JSON) {
    self.data = json
    self.subject = json["subject"].string!
  }
}