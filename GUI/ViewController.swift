//
//  ViewController.swift
//  GUI
//
//  Created by Jonathan Wight on 5/15/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        print(Logger.sharedInstance.queue)
    }
    
    @IBAction func log(sender: AnyObject) {
        print("Submitting")
        stress()
        print("Submitted")
    }
}
