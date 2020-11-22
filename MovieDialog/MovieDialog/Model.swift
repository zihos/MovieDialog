//
//  Model.swift
//  MovieDialog
//
//  Created by linc on 18/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import Foundation
import UIKit

class Movie{
    //모든 속성은 Movie 객체를 생성한 후에 값을 입력해 줄 것이기 때문에 Optional로 정의
    var title:String?
    var link:String?
    var imageURL:String?
    var image:UIImage?
    var pubDate:String?
    var director:String?
    var actors:String?
    var userRating:String?
    
    init() {
        
    }
    
    
    //imageURL을 가지고 URL 객체를 생성하여 이를 가지고 이미지 데이터를 불러온다.
    func getPosterImage() {
        guard imageURL != nil else { //movie 객체의 imageURL이 존재하는지 확인
            print("image is nil")
            return
        }
        
        if let url = URL(string: imageURL!) { //URL 객체 생성
            if let imgData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imgData) {
                    self.image = image //UIImage 생성, self.image에 저장
                }
            }
        }
        return
    }    
}
