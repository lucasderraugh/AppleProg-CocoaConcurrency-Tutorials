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
	
	@IBAction func startImageFall(_ sender: NSButton) {
		let url = URL(fileURLWithPath: "/Library/Desktop Pictures")
		let fileManager = FileManager.default
        let contents = (try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)) ?? []
		
		sender.animator().alphaValue = 0
		
        for url in contents {
			let resourceValues = try? url.resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
            if (resourceValues?.isDirectory ?? true) {
                continue
            }
			
			self.count += 10
            DispatchQueue.global(qos: .default).async { [x = self.count] in
				let view = NSImageView(frame: NSMakeRect(x, self.window.contentView!.frame.height, 300, 200))
                guard let image = NSImage(contentsOf: url)?.thumbnailImage() else {
                    return
                }
                view.image = image
				
				DispatchQueue.main.async {
					self.window.contentView!.addSubview(view)
                    NSAnimationContext.runAnimationGroup({ context in
                        context.duration = 4.0
                        view.animator().setFrameOrigin(NSMakePoint(x, 0))
                    })
				}
			}
		}
	}
}

extension NSImage {
	func thumbnailImage() -> NSImage {
		let thumbnailSize = NSMakeSize(300, 200)
		let thumbnailImage = NSImage(size: thumbnailSize)
		
		thumbnailImage.lockFocus()
		self.draw(in: NSMakeRect(0, 0, thumbnailSize.width, thumbnailSize.height), from: NSZeroRect, operation: NSCompositingOperation.copy, fraction: 1.0)
		thumbnailImage.unlockFocus()
		
		return thumbnailImage
	}
}

