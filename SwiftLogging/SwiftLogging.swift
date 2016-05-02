//
//  SwiftLogging.swift
//  SwiftLogging
//
//  Created by Jonathan Wight on 4/21/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation
import Darwin

class Logger {

    static let sharedInstance = Logger()
    
    var queue: dispatch_queue_t! = dispatch_queue_create("io.schwa.SwiftLogger", DISPATCH_QUEUE_SERIAL)

    var accumulator = 0
    
    func log(event: Event) {
        dispatch_async(queue) {
            autoreleasepool() {
                let s = String(event)
                self.accumulator ^= event.id.hashValue
            }
        }
    }

}

// MARK: -

struct Event {
    let id: Int
}

func stress() {

    let log = Logger.sharedInstance
    
    for N in 0..<500000 {
        autoreleasepool() {
            let event = Event(id: N)
            log.log(event)
        }
    }
}
