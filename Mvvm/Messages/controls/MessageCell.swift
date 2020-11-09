//
//  MessageCell.swift
//  Mvvm
//
//  Created by Naim Ali on 4/3/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
