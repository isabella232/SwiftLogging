//
//  ViewController.swift
//  GUI
//
//  Created by Jonathan Wight on 5/15/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa

import SwiftLogging

class ViewController: NSViewController {

    var counter = 0
    
    @IBAction func log(sender: AnyObject) {
        
        SwiftLogging.log.debug("Starting Log")
        for m in 0..<1 {
            //usleep(useconds_t(5.0 * 100000))
            for n in 0..<64000 {
                
                SwiftLogging.log.info("Hello world: \(m), \(n)")
            }
        }
        
        
    }
}

