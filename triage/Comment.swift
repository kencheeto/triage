//
//  Comment
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import Foundation
private let defaults = NSUserDefaults.standardUserDefaults()
private let API = ZendeskAPI.instance

private var _currentUser: UserFields?
private var _currentUserData: NSDictionary?

struct CommentFields {
  let id: Int
  let author_id: Int
  let user: User?
  let isPublic: Bool
  var body: String
  var htmlBody: String
  var createdAt: String
}

extension CommentFields: JSONDecodable {
  
  static func create(id: Int)
    (author_id: Int)
    (isPublic: Bool)
    (body: String)
    (htmlBody: String)
    (createdAt: String) -> CommentFields {
      
    return CommentFields(
      id: id,
      author_id: author_id,
      user:  nil,
      isPublic: isPublic,
      body: body,
      htmlBody: htmlBody,
      createdAt: createdAt
    )
  }
  
  static func decode(json: JSON) -> CommentFields? {
    return CommentFields.create
      <^> json <| "id"
      <*> json <| "author_id"
      <*> json <| "public"
      <*> json <| "body"
      <*> json <| "html_body"
      <*> json <| "created_at"
  }
  
}

class Comment {
  var fields: CommentFields
  var author: User?
  
  init(fields: CommentFields) {
    self.fields = fields
  }
  
  func createdAgoInWords() -> String {
    var time = TimeUtils.parseJSONTime(fields.createdAt)
    return time.timeAgoSinceNow()
  }
  
  
//  func avatarURL() -> (String) {
//    var emailHash = fields.email.lowercaseString.md5
//    
//    var url = "http://gravatar.com/avatar/\(emailHash)?d=https%3A//assets.zendesk.com/images/types/user_sm.png&s=64&r=g"
//    
//    return url
//    
//  }
  
  
}
