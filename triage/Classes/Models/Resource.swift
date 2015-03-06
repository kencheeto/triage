//
//  Resource.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//


let apiBaseURL = "https://z3nios.zendesk.com/api/v2/"


class Resource {
  var dictionary: NSDictionary?
  var id: Int?
  
  init() {
    
  }
  
  init(dict: NSDictionary) {
    updateFromDict(dict)
  }
  
  func updateFromDict(dict: NSDictionary) {
    assert(false, "override me")
  }
  
  class func resourceUrl(id: Int) -> String {
    assert(false, "override me")
  }
  
  class func resourceName() -> String {
    assert(false, "override me")
  }
  
  
  class func handleFailure(task: NSURLSessionDataTask!, error: NSError!) {
    NSLog("Error %@", error)
  }
  
  class func find(id: Int, completion: (resource: Resource?, error: NSError?) -> ())  {
    var url = resourceUrl(id)
    ApiClient.sharedInstance.GET(url, parameters: nil, success: { (task: NSURLSessionDataTask!, response: AnyObject!) -> Void in
      var hash = response as NSDictionary
      var resourceDict = hash.valueForKey(self.resourceName()) as NSDictionary
      var resource = Resource(dict: resourceDict)
      
      completion(resource: resource, error: nil)
      }, failure: handleFailure)
    
  }
}

