//
//  Macro.swift
//  triage
//
//  Created by Kurt Ruppel on 3/8/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import UIKit

struct MacroAction {
  let field: String
  let value: String
}

extension MacroAction: JSONDecodable {

  static func create(field: String)
    (value: String) -> MacroAction {
      return MacroAction(
        field: field,
        value: value
      )
  }

  static func decode(json: JSON) -> MacroAction? {
    return MacroAction.create
      <^> json <| "field"
      <*> json <| "value"
  }
}

struct Macro {
  let id: Int
  let title: String
  let actions: [MacroAction]
}

extension Macro: JSONDecodable {

  static func create(id: Int)
    (title: String)
    (actions: [MacroAction]) -> Macro {
      return Macro(
        id: id,
        title: title,
        actions: actions
      )
  }

  static func decode(json: JSON) -> Macro? {
    return Macro.create
      <^> json <| "id"
      <*> json <| "title"
      <*> json <|| "actions"
  }
}
