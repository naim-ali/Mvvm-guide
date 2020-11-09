//
//  InstructionsLabel.swift
//  Mvvm
//
//  Created by Sagepath on 2/19/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation

@IBDesignable class InstructionsLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        self.font = UIFont(name: "Frutiger LT COM", size: 14.0)?.italic
        self.textAlignment = .center
    }
}

