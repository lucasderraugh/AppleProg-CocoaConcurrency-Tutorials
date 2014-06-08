//
//  main.m
//  Lesson 1
//
//  Created by Lucas Derraugh on 6/4/14.
//  Copyright (c) 2014 Lucas Derraugh. All rights reserved.
//
//
//  The C sample is more complex than the Swift sample.
//  I added the ability to print an associating thread number for each call.
//  printf() is seamingly threadsafe, while println() in Swift is not, so
//  I didn't include that in the Swift demo

#import <Foundation/Foundation.h>

@interface Simple : NSObject
@property (nonatomic) int val;
- (void)inc1000Times:(NSNumber *)threadNum;
@end

@implementation Simple
- (void)inc1000Times:(NSNumber *)threadNum {
    int num = [threadNum intValue];
    for (int i = 0; i < 1000; i++) {
        int oldVal = self.val;
        printf("T%d Old Val: %d   ", num, oldVal);
        int newVal = oldVal+1;
        self.val = newVal;
        printf("T%d New Val: %d\n", num, newVal);
    }
    printf("Done\n");
}
@end

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        Simple *simple = [[Simple alloc] init];
        [NSThread detachNewThreadSelector:@selector(inc1000Times:)
                                 toTarget:simple
                               withObject:@2];
        [simple inc1000Times:@1];
        sleep(1);
    }
    return 0;
}

