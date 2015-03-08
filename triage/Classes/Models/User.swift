//
//  User.swift
//  triage
//
//  Created by Christopher Kintner on 3/4/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

struct User {

  let id: Int
  let name: String
  let email: String
}

extension User: JSONDecodable {

  static func create(id: Int)(name: String)(email: String) -> User {
    return User(
      id: id,
      name: name,
      email: email
    )
  }

  static func decode(json: JSON) -> User? {
    return User.create
      <^> json <| "id"
      <*> json <| "name"
      <*> json <| "email"
  }
}
