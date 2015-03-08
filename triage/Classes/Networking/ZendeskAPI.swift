//
//  ApiClient.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

let _ZendeskAPIInstance = ZendeskAPI(
  baseURL: APIBaseURL,
  clientID: APIClientID,
  secret: APISecret
)

final class ZendeskAPI: AFOAuth2Manager {

  final class var instance: ZendeskAPI {
    return _ZendeskAPIInstance
  }
}