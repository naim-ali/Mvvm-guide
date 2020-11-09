//
//  FontExtensions.swift
//  Mvvm
//
//  Created by Sagepath on 2/20/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    var bold: UIFont {
        return with(traits: .traitBold)
    } // bold
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    } // italic
    
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    } // boldItalic
    
    func with(traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        } // guard
        
        return UIFont(descriptor: descriptor, size: 0)
    } // with(traits:)
} // extension

extension UILabel {
    func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    func adjust(characterSpacing: Any? = nil, lineHeight: CGFloat? = nil, alignment: NSTextAlignment? = nil) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            if (characterSpacing != nil) {
                attributedString.addAttribute(NSAttributedStringKey.kern, value: characterSpacing!, range: NSRange(location: 0, length: attributedString.length - 1))
            }
            if (lineHeight != nil || alignment != nil) {
                let paragraphStyle = NSMutableParagraphStyle()
                if (lineHeight != nil) {
                    paragraphStyle.minimumLineHeight = lineHeight!
                    paragraphStyle.maximumLineHeight = lineHeight!
                }
                if (alignment != nil) {
                    paragraphStyle.alignment = alignment!
                }
                attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(1, attributedString.length-1))
            }
            attributedText = attributedString
        }
    }
}

extension UIButton {
    func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    func adjust(characterSpacing: Any? = nil, lineHeight: CGFloat? = nil, alignment: NSTextAlignment? = nil) {
        if let labelText = title(for: .normal), labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            if (characterSpacing != nil) {
                attributedString.addAttribute(NSAttributedStringKey.kern, value: characterSpacing!, range: NSRange(location: 0, length: attributedString.length - 1))
            }
            if (lineHeight != nil || alignment != nil) {
                let paragraphStyle = NSMutableParagraphStyle()
                if (lineHeight != nil) {
                    paragraphStyle.minimumLineHeight = lineHeight!
                    paragraphStyle.maximumLineHeight = lineHeight!
                }
                if (alignment != nil) {
                    paragraphStyle.alignment = alignment!
                }
                attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(1, attributedString.length-1))
            }
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: titleColor(for: .normal) ?? Project.Colors.white, range:NSMakeRange(0, attributedString.length))
            setAttributedTitle(attributedString, for: .normal)
        }
    }
}
