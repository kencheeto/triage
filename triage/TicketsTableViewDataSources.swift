//
//  EmptyTableSource.swift
//  triage
//
//  Created by Christopher Kintner on 3/10/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import Foundation

class EmptyTableViewSource: NSObject, UITableViewDataSource {
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("EmptyTableViewCell") as EmptyTableViewCell
    
    return cell
  }
  
  
  
}

class LoadingTableViewSource: NSObject, UITableViewDataSource {
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("LoadingTableViewCell") as LoadingTableViewCell
    
    return cell
  }
  
  
}