//
//  user.swift
//  MovieDialog
//
//  Created by In Taek Cho on 17/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import Foundation

class User: Codable {
    var numberOfStar:Int
    var numberOfMovie:Int
    var numberOfReview:Int
}

extension User: CustomStringConvertible {
    var description: String {
        return "User<\(numberOfStar), \(numberOfMovie), \(numberOfReview)>"
    }
}
