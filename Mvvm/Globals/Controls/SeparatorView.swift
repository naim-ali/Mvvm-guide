//
//  SeparatorView.swift
//  Mvvm
//
//  Created by Sagepath on 2/19/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation

@IBDesignable class SeparatorView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        //let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 1)
        //self.addConstraint(heightConstraint)
        
        self.backgroundColor =  Project.Colors.lightGray
    }
}
