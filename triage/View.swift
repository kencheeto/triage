//
//  View.swift
//  triage
//
//  Created by Christopher Kintner on 3/5/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import Foundation

struct VIEWS {
  static let untriaged = 47205968
}



class View: Resource {
  let ticketsPerPage = 20;
  
  
  func untriagedTickets(completion: (tickets: [Ticket], error: NSError) -> ()) {
    var url = "/api/v2/views/\(VIEWS.untriaged)/tickets.json"
    
    View.findAll(url, completion: { (resources, error) -> () in
      var items = resources?.map { $0 as Ticket}
    })
    
  
  
  }
  
}