//
//  main.swift
//  StressTest
//
//  Created by Jonathan Wight on 5/3/16.
//  Copyright © 2016 schwa.io. All rights reserved.
//

import Foundation
import Darwin

class Event {
    let id = Int(arc4random())
}

func stress(count count: Int, queue: dispatch_queue_t) {

    var accumulator = 0
    func log(event: Event) {
        dispatch_async(queue) {
            accumulator ^= String(event.id).hashValue
        }
    }

    print("Submitting events")

    for N in 0..<count {
        if N % (count / 20) == 0 {
            dumpMemory()
        }
        let event = Event()
        log(event)
    }

    dispatch_async(queue) {
        print("All events processed")
        dumpMemory()
    }

    print("Submitted events")
}

func dumpMemory() {
    var usage = rusage()
    if getrusage(RUSAGE_SELF, &usage) != 0 {
        fatalError()
    }
    print("Memory: \(Double(usage.ru_maxrss) / (1024 * 1024)) MiB")
}

// MARK: main

print("Sleeping for 2 seconds")
sleep(2)

let mainQueue = dispatch_queue_create("background", DISPATCH_QUEUE_SERIAL)
let workerQueue = dispatch_queue_create("io.schwa.SwiftLogger", DISPATCH_QUEUE_SERIAL)

dispatch_async(mainQueue) {
    stress(count: 1_000_000, queue: workerQueue)
}

dispatch_main()
