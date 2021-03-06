//
//  Ticket.swift
//  triage
//
//  Created by Kurt Ruppel on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

private let API = ZendeskAPI.instance

struct Ticket {
  let id: Int
  var subject: String
  let description: String
  var status: String?
  var priority: String?
  var assignee_id: Int?
  var group_id: Int?
  var created_at: String? //swift hangs if this is a NSDate in the create function below
  var requester: User?
}

extension Ticket: JSONDecodable, JSONSerializable {
  
  static func create(id: Int)
    (subject: String)
    (description: String)
    (status: String?)
    (priority: String?)
    (assignee_id: Int?)
    (group_id: Int?)
    (created_at: String?) -> Ticket {
    return Ticket(
      id: id,
      subject: subject,
      description: description,
      status: status,
      priority: priority,
      assignee_id: assignee_id,
      group_id: group_id,
      created_at: created_at,
      requester: nil
    )
  }

  static func decode(json: JSON) -> Ticket? {
   
    return Ticket.create
      <^> json <| "id"
      <*> json <| "subject"
      <*> json <| "description"
      <*> json <|? "status"
      <*> json <|? "priority"
      <*> json <|? "assignee_id"
      <*> json <|? "group_id"
      <*> json <|? ["last_comment", "created_at"]
  }

  func save(#success: ((operation: AFHTTPRequestOperation!, ticket: Ticket) -> Void)?,
    failure: ((operation: AFHTTPRequestOperation!, error: NSError) -> Void)?) -> Void {
    API.updateTicket(
      self,
      success: { (operation, response) -> Void in
        _ = success?(operation: operation, ticket: self)
      },
      failure: failure
    )
  }

  func toDictionary() -> NSDictionary {
    return [
      "id": id,
      "subject": subject,
      "description": description,
      "status": status ?? NSNull(),
      "priority": priority ?? NSNull(),
      "assignee_id": assignee_id ?? NSNull(),
      "group_id": group_id ?? NSNull(),
      "created_at": created_at ?? NSNull()
    ]
  }

  func createdAtInWords() -> String {
    if let time = created_at {
      return TimeUtils.parseJSONTime(time).timeAgoSinceNow()
    } else {
      return ""
    }
  }

  
  func createAtInEnglish() -> String {
    if let time = created_at {
      var date = TimeUtils.parseJSONTime(time)
      return TimeUtils.Struct.dayFormatter.stringFromDate(date)
    } else {
      return ""
    }
  }
}
