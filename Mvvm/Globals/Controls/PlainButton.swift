//
//  KKButton.swift
//  Mvvm
//
//  Created by Sagepath on 2/12/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class PlainButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.setTitleColor(Project.Colors.darkGreen, for: .normal)
        self.titleLabel?.font = UIFont(name: "Frutiger LT Com", size: 13.0)
    }
}



