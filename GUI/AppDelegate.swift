//
//  AppDelegate.swift
//  GUI
//
//  Created by Jonathan Wight on 5/15/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa

import SwiftLogging

public class NilDestination: Destination {
    public let formatter: EventFormatter
    
    public init(formatter: EventFormatter = terseFormatter) {
        self.formatter = formatter
    }
    
    var accumalatedHashes: Int = 0
    
    public override func receiveEvent(event: Event) {
//        dispatch_async(logger.consoleQueue) {
//            [weak self] in
//            guard let strong_self = self else {
//                return
//            }
//
//            let strong_self = self
//            let string = String(event)
//            strong_self.accumalatedHashes ^= string.hashValue
            print(event)
        }
//    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {

        let logger = SwiftLogging.log
  
        logger.addDestination("io.schwa.SwiftLogging.nil", destination: NilDestination(formatter: simpleFormatter))
        
        
        // Logging to console.
//        logger.addDestination("io.schwa.SwiftLogging.console", destination: ConsoleDestination())
        
//        // Add source filter
//        console.addFilter(sourceFilter(pattern: ".*"))
        
        //    // Add duplications filter
        //    console.addFilter(duplicatesFilter(timeout: 5.0))
        
//        // Add verbosity filter
//        console.addFilter(verbosityFilter())
        
        // Logging to file.
//        let fileDestination = FileDestination()
//        fileDestination.addFilter(sensitivityFilter)
//        logger.addDestination("io.schwa.SwiftLogging.default-file", destination: fileDestination)
        
       
        //        log.addDestination("server", destination: try! LogServerDestination())

        // MOTD
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        let processInfo = NSProcessInfo.processInfo()
        let items = [
            ("App Name", infoDictionary["CFBundleName"] ?? "?"),
            ("App Identifier", infoDictionary["CFBundleIdentifier"] ?? "?"),
            ("App Version", infoDictionary["CFBundleVersion"] ?? "?"),
            ("App Version", infoDictionary["CFBundleShortVersionString"] ?? "?"),
            ("Operating System", processInfo.operatingSystemVersionString),
            ("PID", "\(processInfo.processIdentifier)"),
            ("Hostname", "\(processInfo.hostName)"),
            ("Locale", NSLocale.currentLocale().localeIdentifier),
            ]
        
        logger.motd(items, priority: .Info, tags: Tags([preformattedTag, verboseTag]))

      


        log.debug("My password is \"123456\"", tags: [sensitiveTag])
        log.debug("Poop: \n💩")
        log.debug("This is so verbose", tags: [verboseTag])
        log.debug("This is so very verbose", tags: [veryVerboseTag])

    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }
}

