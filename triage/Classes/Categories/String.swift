//
//  String.swift
//  triage
//
//  Created by Christopher Kintner on 3/10/15.
//  Copyright (c) 2015 KSCK. All rights reserved.
//

import Foundation



// from http://stackoverflow.com/a/24408724

extension String  {
  var md5: String! {
    let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
    let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
    
    CC_MD5(str!, strLen, result)
    
    var hash = NSMutableString()
    for i in 0..<digestLen {
      hash.appendFormat("%02x", result[i])
    }
    
    result.dealloc(digestLen)
    
    return String(format: hash)
  }
}