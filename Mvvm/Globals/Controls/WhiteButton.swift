//
//  KKButton.swift
//  Mvvm
//
//  Created by Sagepath on 2/12/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class WhiteButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 56)
        self.addConstraint(heightConstraint)
        
        self.backgroundColor = Project.Colors.white
        self.layer.cornerRadius = heightConstraint.constant / 2
        
        self.setTitleColor(Project.Colors.darkGreen, for: .normal)
        self.titleLabel?.font = UIFont(name: "Brandon Grotesque", size: 15.0)
        
        self.layer.shadowColor = Project.Colors.gray.cgColor
        self.layer.shadowRadius = 20.0
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset.height = 15.0
    }
}


