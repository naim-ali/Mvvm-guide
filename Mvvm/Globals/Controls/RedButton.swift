//
//  KKButton.swift
//  Mvvm
//
//  Created by Sagepath on 2/12/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RedButton : UIButton {
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
        
        self.backgroundColor =  Project.Colors.red
        self.layer.cornerRadius = heightConstraint.constant / 2
        
        self.setTitleColor(Project.Colors.white, for: .normal)
        self.titleLabel?.font = UIFont(name: "Brandon Grotesque", size: 15.0)
        
        self.layer.shadowColor = Project.Colors.red.cgColor
        self.layer.shadowRadius = 20.0
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset.height = 8.0
    }
}

