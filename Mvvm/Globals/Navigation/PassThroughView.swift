//
//  PassThroughView.swift
//  Mvvm
//
//  Created by Sean Davis on 12/7/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class PassThroughView: UIView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}
