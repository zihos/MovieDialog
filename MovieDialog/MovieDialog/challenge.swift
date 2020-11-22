//
//  challenge.swift
//  MovieDialog
//
//  Created by In Taek Cho on 17/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import Foundation

class Challenge: Codable {
    var title:String
    var time:Date
    var startTime:Date
    var goal:Int
    var now:Int
    
    init(title:String,time:Date,startTime:Date,goal:Int,now:Int) {
        self.title=title
        self.time=time
        self.startTime=startTime
        self.goal=goal
        self.now=now
    }
}

extension Challenge: CustomStringConvertible {
    var description: String {
        return "\(title), \(time), \(startTime), \(goal), \(now)"
    }
}
