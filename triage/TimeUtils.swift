//
//  TimeUtils.swift
//  triage
//
//  Created by Christopher Kintner on 3/17/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import Foundation

class TimeUtils {
   struct Struct {
    static var jsonDateFormatter = TimeUtils.dateFormatter(formatString: "yyyy-MM-dd'T'HH:mm:ssz")
    static var dayFormatter = TimeUtils.dateFormatter(formatString: "MMM d, y")
  }

  private class func dateFormatter(#formatString: String) -> NSDateFormatter {
    var df = NSDateFormatter()
    df.dateFormat = formatString
    return df
  }
  
  class func parseJSONTime(time: String) -> NSDate {
    return Struct.jsonDateFormatter.dateFromString(time)!
  }

}