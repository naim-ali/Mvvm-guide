//
//  PaymentMethodTableViewCell.swift
//  Mvvm
//
//  Created by Sean Davis on 12/12/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentMethodImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var primaryPaymentMethodLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
