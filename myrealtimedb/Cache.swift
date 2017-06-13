//
//  Cache.swift
//  myrealtimedb
//
//  Created by AgribankCard on 6/12/17.
//  Copyright © 2017 cuongpc. All rights reserved.
//

import Foundation

class Cache {
    static var images : NSCache<NSString, AnyObject> = {
        let result = NSCache<NSString, AnyObject>()
        result.countLimit = 30
        result.totalCostLimit = 10 * 1024 * 1024
        return result
    }()
}
