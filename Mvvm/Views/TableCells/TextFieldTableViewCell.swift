//
//  TextFieldTableViewCell.swift
//  Sagepath
//
//  Created by Sean Davis on 12/5/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: InputTableViewCell {
    
    var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func commonInit()
    {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        textField.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        textField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(divider)
        
        AddConstraintsFor(divider: divider, below: textField)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
                
        label.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 3.0).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        label.text = "label"
        
        // styles
        
        textField.font = UIFont(name: "Helvetica", size: 30.0)
    }

}

