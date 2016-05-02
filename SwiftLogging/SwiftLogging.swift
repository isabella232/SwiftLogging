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
    
    let queue: dispatch_queue_t = dispatch_queue_create("io.schwa.SwiftLogger", DISPATCH_QUEUE_SERIAL)

    var accumulator = 0
    
    func log(event: Event) {
        dispatch_async(queue) {
            self.accumulator ^= String(event.id).hashValue
        }
    }

}

// MARK: -

class Event {
    let id = Int(arc4random())
//    let memory = NSMutableData(length: 16)
}

func stress() {

    let log = Logger.sharedInstance
    
    let count = 20_000_000
    for N in 0..<count {
        autoreleasepool() {
            let event = Event()
//            if N % 100 == 0 {
//                usleep(useconds_t(0.00001 * Double(USEC_PER_SEC)))
//            }
//            log.log(event, last: N == count - 1)
            log.log(event)
        }
    }
}

