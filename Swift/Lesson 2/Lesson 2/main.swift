//
//  main.swift
//  Lesson 2
//
//  Created by Lucas Derraugh on 6/11/14.
//  Copyright (c) 2014 Lucas Derraugh. All rights reserved.
//

import Foundation

class Simple: NSObject {
    let lock = NSLock()
    var val = 0
    func incrVal1000() {
        for _ in 0..<1000 {
            lock.lock()
            let v = val + 1
            print("Val+1: \(v)")
            val = v
            lock.unlock()
        }
    }
}

let s = Simple()
NSThread.detachNewThreadSelector("incrVal1000", toTarget: s, withObject: nil)
s.incrVal1000()

sleep(1)
