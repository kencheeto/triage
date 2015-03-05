//
//  ApiClient.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

let zendeskURL = NSURL(string: "https://z3nios.zendesk.com/")
let clientSecret = "88e575788cca935a31fb64803a72b51c0c0e383238716e9b6fd4a71d1d6fc86f"
let clientID = "triage_zendesk_app"

class ApiClient: AFHTTPSessionManager {
  
  class var sharedInstance: ApiClient {
    struct Static {
      static let instance = ApiClient()
    }
    return Static.instance
  }
  
  init() {
    var config = NSURLSessionConfiguration()
    super.init(baseURL: zendeskURL, sessionConfiguration: config)
    requestSerializer = AFJSONRequestSerializer() as AFJSONRequestSerializer // #wtf apple
    responseSerializer = AFJSONResponseSerializer() as AFJSONResponseSerializer
    
  }


  required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  func setToken(token: String) {
    self.session.configuration.HTTPAdditionalHeaders = ["Authorization":  "Bearer \(token)"]
  }
  
  func getAccessToken(email: String, password: String) -> String {
    var url = "/oauth/tokens"
    var params = ["grant_type": "password", "client_id": clientID, "client_secret": clientSecret, "scope": "read write", "username": email, "password": password]
    
    var onSuccess = {(task: NSURLSessionDataTask!, response: AnyObject!) -> () in
      
      NSLog("response: %@", task)
      
    }
   
    POST(url, parameters: params, success: onSuccess, failure: handleFailure)
    
    
    return "adf"
  }
  
  
  
  func handleFailure(task: NSURLSessionDataTask!, error: NSError!) {
    NSLog("Error %@", error)
  }
  
  
  /*
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:@"http://example.com/resources.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
  NSLog(@"JSON: %@", responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
  NSLog(@"Error: %@", error);
  }];
  */
}