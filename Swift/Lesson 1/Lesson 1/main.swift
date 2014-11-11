//
//  main.swift
//  Lesson 1
//
//  Created by Lucas Derraugh (@lucasderraugh) on 6/8/14.
//  Copyright (c) 2014 Lucas Derraugh. All rights reserved.
//

import Foundation

class Simple: NSObject {
    var val = 0
    func incrVal1000() {
        for _ in 0..<1000 {
            let v = val + 1
            println(v)
            val = v
        }
    }
}

let s = Simple()
NSThread.detachNewThreadSelector("incrVal1000", toTarget: s, withObject: nil)
s.incrVal1000()

sleep(1)
