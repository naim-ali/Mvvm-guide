//
//  RewardsProgressTableViewCell.swift
//  Mvvm
//
//  Created by Sean Davis on 12/11/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class RewardsProgressTableViewCell: UITableViewCell {

    @IBOutlet weak var rewardImage: UIImageView!
    @IBOutlet weak var circularProgressView: MBCircularProgressBarView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var rewardDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
