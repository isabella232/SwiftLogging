//
//  main.swift
//  LeakyQueye
//
//  Created by Jonathan Wight on 5/3/16.
//  Copyright © 2016 schwa.io. All rights reserved.
//

import Foundation
import Darwin

/*
Leaky queue.

Originally adapted from my logging code that would log events in the background.

This code submits a lot (millions work "best") of closures to a serial queue.
Each submission consumes memory but the memory isn't freed even once the
closures have all been dequeued.

It leaks with SWIFT_OPTIMIZATION_LEVEL = -Owholemodule or -Ofast or -Onone

This code leaks when compiled with swift 2.2 or swift 3 (some minor syntax
adaptions needed).
It leaks as part of a OS X command line tool, OS X app or iOS app.
The memory is not cleaned up if I let it run after completing.
Sprinkling relevent code with autoreleasepool() doesn't affect memory usage
(more applicable with previous versions of this code).
Switch to dispatch_async_f and passing in a nil context _does_ (seem to) fix the
memory issues..
*/


func stress(count count: Int, queue: dispatch_queue_t) {
    print("Submitting events. (Memory usage should climb rapidly)")

    var processedCount = 0 // Only ever accessed serially.

    for index in 0..<count {
        // Change to dispatch_sync or remove entirely to prevent leaks.
        dispatch_async(queue) {
            // Absence of following line does nto seem to affect memory growth.
            processedCount += 1
        }
        if (index + 1) % (count / 10) == 0 {
            print("\(index + 1) submitted.")
        }
    }

    dispatch_async(queue) {
        print("Done processing \(processedCount) events. Exiting after delay. (Should expect memory usage to fall here.)")
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(240 * NSEC_PER_SEC)), queue) {
            print("Exiting")
            exit(0)
        }
    }

    print("Submitted events (Memory usage should have peaked by now)")
}

// MARK: main

let count = 40_000_000 // On my 32GB retina iMac this causes code to consume just under 4GB of RAM.

print("PID \(getpid())")

print("Sleeping for 30 seconds")
sleep(30)

let mainQueue = dispatch_queue_create("stress.main", DISPATCH_QUEUE_SERIAL)
let workerQueue = dispatch_queue_create("stress.worker", DISPATCH_QUEUE_SERIAL)

// Submit events on the "main" queue.
dispatch_async(mainQueue) {
    stress(count: count, queue: workerQueue)
}

dispatch_main()

