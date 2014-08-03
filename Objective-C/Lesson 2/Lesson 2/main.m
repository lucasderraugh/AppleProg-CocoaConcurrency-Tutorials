//
//  main.m
//  Lesson 2
//
//  Created by Lucas Derraugh on 8/3/14.
//  Copyright (c) 2014 Lucas Derraugh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Simple : NSObject
- (void)incrVal1000;
@end

@implementation Simple {
    NSLock *lock;
    int val;
}

- (instancetype)init {
    if (self = [super init]) {
        lock = [[NSLock alloc] init];
        val = 0;
    }
    return self;
}

- (void)incrVal1000 {
    for (int i = 0; i < 1000; i++) {
        [lock lock];
        int v = val + 1;
        NSLog(@"%@", [NSString stringWithFormat:@"Val+1: %d", v]);
        val = v;
        [lock unlock];
    }
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Simple *s = [[Simple alloc] init];
        [NSThread detachNewThreadSelector:@selector(incrVal1000) toTarget:s withObject:nil];
        [s incrVal1000];
        
        sleep(1);
    }
    return 0;
}
