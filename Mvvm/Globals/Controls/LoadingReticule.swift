//
//  LoadingReticule.swift
//  Mvvm
//
//  Created by Naim Ali on 2/28/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit

@IBDesignable class LoadingReticule: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    static let sharedInstance = LoadingReticule()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        let window = UIApplication.shared.keyWindow!
        
        self.frame = window.bounds
        self.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        let loadingGif = UIImage.gifImageWithName("kk_loader@2x")
        let imageView = UIImageView(image: loadingGif)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 240*0.4, height: 150.0*0.4)
        imageView.center = self.center
        self.addSubview(imageView)
        
        window.addSubview(self);
    }
    
    public func display(){
        self.alpha = 1
    }
    
    public func hide(){
        self.alpha = 0
    }
    

}
