//
//  PasswordTableViewCell.swift
//  Sagepath
//
//  Created by Sean Davis on 12/5/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class PasswordTableViewCell: TextFieldTableViewCell {
    
    var passwordAccessory: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit()
    {
        textField.isSecureTextEntry = true
        
        let accessoryImage = UIImage(named: "passwordAccessory.png")
        passwordAccessory = UIImageView(image: accessoryImage)
        textField.rightView = passwordAccessory
        textField.rightViewMode = .always
    }
    
}
