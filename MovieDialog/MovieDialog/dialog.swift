//
//  dialog.swift
//  MovieDialog
//
//  Created by In Taek Cho on 17/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import Foundation

class Dialog: Codable {
    var title:String
    var image:String
    var date:String
    var star:Int
    var simpleReview:[String]
    var review:String
    var createdDate:String
    
    init(title:String,image:String,date:String,star:Int,simpleReview:[String],review:String,createdDate:String){
        self.title=title
        self.image=image
        self.date=date
        self.star=star
        self.simpleReview=simpleReview
        self.review=review
        self.createdDate=createdDate
    }
}

extension Dialog: CustomStringConvertible {
    var description: String {
        return "\(title), \(image), \(date), \(star), \(simpleReview), \(review), \(createdDate)"
    }
}
