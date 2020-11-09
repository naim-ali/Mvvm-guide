//
//  TextField.swift
//  Mvvm
//
//  Created by Sagepath on 2/19/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation

@IBDesignable class TextField: UITextField {
    
    var hasError : Bool!
    var staticBorder : CALayer!
    var animatedBorder : CALayer!
    var label : UILabel!
    
    
    // Error label text
    var errTxt : String! = "" {
        didSet {
            label.text = errTxt
            self.setErrorState()
        }
    }
    
    // Default label text
    var defaultTxt : String! = "" {
        didSet {
            label.text = defaultTxt
            label.adjust(characterSpacing: 0.8)
            self.setDefaultState()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        // set up underline frame
        staticBorder.frame = CGRect(x: 0, y: self.frame.size.height - 3, width:  self.frame.size.width, height: 1)
        
        // set up label frame
        var frame = self.frame;
        frame.origin.y = frame.size.height + 3
        frame.origin.x = 0
        label.frame = frame
        
        super.draw(rect)
    }
    
    private func setup() {

        self.hasError = false
        
        let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 32)
        self.addConstraint(heightConstraint)
        self.clipsToBounds = false
        self.borderStyle = .none
        self.font = UIFont(name: "Frutiger LT Com", size: 24.0)
        
        // Add border
        staticBorder = CALayer()
        let width = CGFloat(1.0)
        staticBorder.borderColor = UIColor.lightGray.cgColor
        staticBorder.borderWidth = width
        self.layer.addSublayer(staticBorder)
        self.layer.masksToBounds = false
        
        // Add label
        label = UILabel()
        
        self.addSubview(label)
    }
    
    //Field became active
    public func focus(){
        if animatedBorder == nil{
            animatedBorder = CALayer()
            let width = CGFloat(1.0)
            animatedBorder.borderColor = UIColor(red:0.07, green:0.41, blue:0.22, alpha:1.0).cgColor
            animatedBorder.frame = CGRect(x: 0, y: self.frame.size.height - 3, width:  self.frame.size.width, height: 1)
            animatedBorder.borderWidth = width
            self.layer.addSublayer(animatedBorder)
            self.layer.masksToBounds = false
        }
        if !hasError{
            move(animatedBorder, to: CGRect(x:0, y:(self.frame.size.height - 3), width: self.frame.size.width, height: 1))
        }
    }
    
    //Field became inactive
    public func blur(){
        move(animatedBorder, to: CGRect(x:0, y:(self.frame.size.height - 3), width:0 , height: 1))
    }
    
    //error state for view
    public func setErrorState(){
        hasError = true
        label.font = UIFont(name: "Frutiger LT COM", size: 14.0)?.italic
        label.textColor = UIColor.red
        staticBorder.borderColor = UIColor.red.cgColor
    }
    
    //default state for view
    public func setDefaultState(){
        hasError = false
        label.font = UIFont(name: "Brandon Grotesque", size: 10.0)
        label.textColor = UIColor(red:0.07, green:0.41, blue:0.22, alpha:1.0)
        staticBorder.borderColor = UIColor.lightGray.cgColor
    }
    
    //animate border
    func move(_ layer: CALayer, to rect: CGRect) {
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.fromValue = layer.value(forKey: "bounds")
        animation.toValue = NSValue(cgRect: rect)
        animation.duration = 0.2
        layer.bounds = rect
        layer.add(animation, forKey: "bounds")
    }
}
