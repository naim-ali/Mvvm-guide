//
//  SubMenuButton.swift
//  Mvvm
//
//  Created by Sagepath on 2/21/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation

@IBDesignable class SubMenuButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        self.backgroundColor =  Project.Colors.red
        self.setTitleColor(Project.Colors.white, for: .normal)
        self.titleLabel?.font = UIFont(name: "Brandon Grotesque", size: 13.0)
    }
}
