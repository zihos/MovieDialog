//
//  MyGoalCell.swift
//  MovieDialog
//
//  Created by linc on 21/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit

class MyGoalCell: UITableViewCell {
    
    @IBOutlet weak var goalName: UILabel!   //목표 이름
    @IBOutlet weak var goalRate: UILabel!   //목표 달성률
    @IBOutlet weak var progressFront: UIView!   //목표 진행 바
    @IBOutlet weak var progressBack: UIView!    //목표 진행 바 배경
    @IBOutlet weak var goalDday: UILabel!   //목표 디데이
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
