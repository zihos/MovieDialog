//
//  MyGoalListCell.swift
//  MovieDialog
//
//  Created by linc on 21/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit

class MyGoalListCell: UITableViewCell {
    @IBOutlet weak var goalListTitle: UILabel!
    @IBOutlet weak var goalListDate: UILabel!
    @IBOutlet weak var goalListNum: UILabel!
    @IBOutlet weak var goalListImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
