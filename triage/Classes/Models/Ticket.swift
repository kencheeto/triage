//
//  Ticket.swift
//  triage
//
//  Created by Kurt Ruppel on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

class Ticket: Resource {

  internal var data: JSON

  var subject: String
  

  init(json: JSON) {
    self.data = json
    self.subject = json["subject"].string!
    super.init()
  }
  
  
  override class func resourceUrl(id: Int) -> String {
    return "/api/v2/tickets/\(id).json"
  }
  
  override class func resourceName() -> String {
    return "ticket"
  }
  
  override func updateFromDict(dict: NSDictionary) {
    
    
    
  }
  
}