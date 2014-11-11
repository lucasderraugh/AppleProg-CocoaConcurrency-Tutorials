//
//  AppDelegate.m
//  Lesson 3
//
//  Created by Lucas Derraugh on 11/11/14.
//  Copyright (c) 2014 Lucas Derraugh. All rights reserved.
//

#import "AppDelegate.h"

@implementation NSImage (Thumbail)

- (NSImage *)thumbnailImage {
    NSSize thumbnailSize = NSMakeSize(300, 200);
    NSImage *thumbnailImage = [[NSImage alloc] initWithSize:thumbnailSize];
    
    [thumbnailImage lockFocus];
    [self drawInRect:NSMakeRect(0, 0, thumbnailSize.width, thumbnailSize.height) fromRect:NSZeroRect operation:NSCompositeColor fraction:1.0];
    [thumbnailImage unlockFocus];
    
    return thumbnailImage;
}

@end


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate {
    CGFloat count;
}

- (IBAction)startImageFall:(NSButton *)sender {
    NSURL *url = [NSURL fileURLWithPath:@"/Library/Desktop Pictures"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    
    sender.animator.alphaValue = 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSURL *element in dirEnum) {
            NSNumber *isDir;
            [element getResourceValue:&isDir forKey:NSURLIsDirectoryKey error:NULL];
            if ([isDir isEqualToNumber:@YES])
                continue;
            
            count += 10;
            NSImageView *view = [[NSImageView alloc] initWithFrame:NSMakeRect(count, [(NSView *)self.window.contentView frame].size.height, 300, 200)];
            view.image = [[[NSImage alloc] initByReferencingURL:element] thumbnailImage];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.window.contentView addSubview:view];
                [NSAnimationContext beginGrouping];
                [NSAnimationContext currentContext].duration = 4.0;
                [view.animator setFrameOrigin:NSMakePoint(count, 0)];
                [NSAnimationContext endGrouping];
            });
        }
    });
}

@end
