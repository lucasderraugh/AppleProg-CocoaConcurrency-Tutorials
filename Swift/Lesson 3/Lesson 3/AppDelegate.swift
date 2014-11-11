//
//  AppDelegate.swift
//  Lesson 3
//
//  Created by Lucas Derraugh on 10/14/14.
//  Copyright (c) 2014 Lucas Derraugh. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    var count: CGFloat = 0.0
    
    @IBAction func startImageFall(sender: NSButton) {
        let url = NSURL(fileURLWithPath: "/Library/Desktop Pictures")
        let fileManager = NSFileManager.defaultManager()
        let dirEnum = fileManager.enumeratorAtURL(url!, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles, errorHandler: nil)
        
        sender.animator().alphaValue = 0
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            while let element = dirEnum?.nextObject() as? NSURL {
                var isDirectory: AnyObject?
                element.getResourceValue(&isDirectory, forKey: NSURLIsDirectoryKey, error: nil)
                if let isDir = isDirectory as? NSNumber {
                    if isDir == NSNumber(int: 1) {
                        continue
                    }
                }
                
                self.count += 10
                let view = NSImageView(frame: NSMakeRect(self.count, (self.window.contentView as NSView).frame.height, 300, 200))
                view.image = NSImage(contentsOfURL: element)!.thumbnailImage()
                
                dispatch_sync(dispatch_get_main_queue(), {
                    (self.window.contentView as NSView).addSubview(view)
                    NSAnimationContext.beginGrouping()
                    NSAnimationContext.currentContext().duration = 4.0
                    view.animator().setFrameOrigin(NSMakePoint(self.count, 0))
                    NSAnimationContext.endGrouping()
                })
            }
        })
    }
}

extension NSImage {
    func thumbnailImage() -> NSImage {
        let thumbnailSize = NSMakeSize(300, 200)
        let thumbnailImage = NSImage(size: thumbnailSize)
        
        thumbnailImage.lockFocus()
        self.drawInRect(NSMakeRect(0, 0, thumbnailSize.width, thumbnailSize.height), fromRect: NSZeroRect, operation: NSCompositingOperation.CompositeCopy, fraction: 1.0)
        thumbnailImage.unlockFocus()
        
        return thumbnailImage
    }
}

