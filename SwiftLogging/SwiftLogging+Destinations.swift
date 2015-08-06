//
//  SwiftLogging+Destinations.swift
//  SwiftLogging
//
//  Created by Jonathan Wight on 5/6/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

public class ConsoleDestination: Destination {
    public let formatter:EventFormatter

    public init(formatter:EventFormatter = terseFormatter) {
        self.formatter = formatter
    }

    public override func receiveEvent(event:Event) {
        dispatch_async(logger.consoleQueue) {
            let string = self.formatter(event)
            println(string)
        }
    }
}

// MARK -

public class MemoryDestination: Destination {
    public internal(set) var events:[Event] = []

    public override func receiveEvent(event:Event) {
        events.append(event)
    }
}

// MARK: -

public class FileDestination: Destination {

    public let url:NSURL
    public let formatter:EventFormatter

    public let queue = dispatch_queue_create("io.schwa.SwiftLogging.FileDestination", DISPATCH_QUEUE_SERIAL)
    public var open:Bool = false
    var channel:dispatch_io_t!

    public init(url:NSURL = FileDestination.defaultFileDestinationURL, formatter:EventFormatter = preciseFormatter) {
        self.url = url
        self.formatter = formatter
        super.init()
    }

    public override func startup() {

        let parentURL = url.URLByDeletingLastPathComponent!

        if NSFileManager().fileExistsAtPath(parentURL.path!) == false {
            NSFileManager().createDirectoryAtURL(parentURL, withIntermediateDirectories: true, attributes: nil, error:nil)
        }

        self.channel = dispatch_io_create_with_path(DISPATCH_IO_STREAM, url.fileSystemRepresentation, O_CREAT | O_WRONLY | O_APPEND, 0o600, queue) {
            (error:Int32) -> Void in
            self.logger.internalLog("ERROR: \(error)")
        }
        if self.channel != nil {
            self.open = true
        }
    }

    public override func shutdown() {
        dispatch_sync(queue) {
            [unowned self] in
            self.open = false
            dispatch_io_close(self.channel, 0)
        }
    }

    public override func receiveEvent(event:Event) {
        dispatch_async(queue) {
            [weak self] in

            if let strong_self = self {
                if strong_self.open == false {
                    strong_self.logger.internalLog("File not open, skipping")
                    return
                }

                let string = strong_self.formatter(event) + "\n"
                var data = (string as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
                // DISPATCH_DATA_DESTRUCTOR_DEFAULT is missing in swiff
                let dispatchData = dispatch_data_create(data.bytes, data.length, strong_self.queue, nil)

                dispatch_io_write(strong_self.channel, 0, dispatchData, strong_self.queue) {
                    (done:Bool, data:dispatch_data_t!, error:Int32) -> Void in
                    strong_self.logger.internalLog(("dispatch_io_write", done, data, error))

                }
            }
        }
    }

    public static var defaultFileDestinationURL:NSURL {
        let fileManager = NSFileManager()
        var url = fileManager.URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)!
        let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier
        let bundleName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String
        url = url.URLByAppendingPathComponent("\(bundleIdentifier)/Logs/\(bundleName).log")
        return url
    }

}
