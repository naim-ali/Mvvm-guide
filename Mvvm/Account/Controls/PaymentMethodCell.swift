//
//  PaymentMethodCell.swift
//  Mvvm
//
//  Created by Naim Ali on 3/22/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var lastFour: UILabel!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var primary: UILabel!
    @IBOutlet weak var balance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
