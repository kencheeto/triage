//
//  JSONSerializable.swift
//  triage
//
//  Created by Kurt Ruppel on 3/8/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

protocol JSONSerializable {
  typealias ModelType = Self
  class func toDictionary(model: ModelType) -> NSDictionary
}
