//
//  TextView.swift
//  Mvvm
//
//  Created by Sagepath on 2/28/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation

@IBDesignable class TextView: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
