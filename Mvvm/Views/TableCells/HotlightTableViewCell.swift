//
//  HotlightTableViewCell.swift
//  Mvvm
//
//  Created by Sean Davis on 12/12/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class HotlightTableViewCell: UITableViewCell {

    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
