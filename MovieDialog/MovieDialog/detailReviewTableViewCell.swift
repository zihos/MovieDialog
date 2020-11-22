//
//  detailReviewTableViewCell.swift
//  MovieDialog
//
//  Created by In Taek Cho on 30/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit

class detailReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
