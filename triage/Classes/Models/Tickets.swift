//
//  Tickets.swift
//  triage
//
//  Created by Kurt Ruppel on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

class Tickets {

  var data: JSON

  lazy internal var items: [Ticket] = []

  init(json: JSON) {
    let rows = json["rows"].array!

    self.data = json
    self.items = rows.map({ Ticket(json: $0) })
  }

  convenience init(fixture: NSString) {
    let bundle = NSBundle.mainBundle()
    let data = NSData(
      contentsOfURL: bundle.URLForResource(fixture, withExtension: "json")!
    )
    let json = JSON(data: data!)

    self.init(json: json)
  }
}