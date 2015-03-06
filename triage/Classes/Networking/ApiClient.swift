//
//  ApiClient.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

let zendeskURL = NSURL(string: "https://z3nios.zendesk.com/")!
let clientSecret = "88e575788cca935a31fb64803a72b51c0c0e383238716e9b6fd4a71d1d6fc86f"
let clientID = "triage_zendesk_app"

class ApiClient: AFHTTPSessionManager {
  
  class var sharedInstance: ApiClient {
    struct Static {
      static let instance = ApiClient()
    }
    return Static.instance
  }
  
  var accessToken: String!
  
  init() {
    var config = NSURLSessionConfiguration.defaultSessionConfiguration()
    config.HTTPShouldSetCookies = false
    
    super.init(baseURL: zendeskURL, sessionConfiguration: config)
    requestSerializer = AFJSONRequestSerializer() as AFJSONRequestSerializer // #wtf apple
    responseSerializer = AFJSONResponseSerializer() as AFJSONResponseSerializer
    
  }

  required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  func setToken(token: String) {
    accessToken = token
    self.session.configuration.HTTPAdditionalHeaders = ["Authorization":  "Bearer \(token)"]
  }
  
  func getAccessToken(email: String, password: String, completion: (token: String) -> ()) {
    var url = "/oauth/tokens"
    var params = ["grant_type": "password", "client_id": clientID, "client_secret": clientSecret, "scope": "read write", "username": email, "password": password]
    
    var onSuccess = {(task: NSURLSessionDataTask!, response: AnyObject!) -> () in
      var hash = response as NSDictionary
      completion(token: hash["access_token"] as String)
    }
   
    POST(url, parameters: params, success: onSuccess, failure: handleFailure)

  }
  
  func handleFailure(task: NSURLSessionDataTask!, error: NSError!) {
    NSLog("Error %@", error)
  }
}