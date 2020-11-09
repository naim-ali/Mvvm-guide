//
//  HotlightViewController.swift
//  Mvvm
//
//  Created by Sagepath on 3/16/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import Foundation

class HotlightViewController: UIViewController {
    
    @IBOutlet weak var hotlightImageView: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var checkNowButton: UIButton!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var subText: UILabel!
    
    @IBAction func close() {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hotlightGif = UIImage.gifImageWithName("hotlight")
        self.hotlightImageView.animationImages = hotlightGif!.images;
        self.hotlightImageView.animationDuration = hotlightGif!.duration;
        self.hotlightImageView.animationRepeatCount = 1;
        self.hotlightImageView.image = hotlightGif!.images?.last;
        hotlightImageView.startAnimating()
        
        mainTitle.adjust(characterSpacing: 2, lineHeight: 32, alignment: .center)
        mainText.adjust(lineHeight: 21, alignment: .center)
        checkNowButton.adjust(characterSpacing: 1)
        subTitle.adjust(characterSpacing: 1.1, lineHeight: 24)
        subText.adjust(lineHeight: 21)
    }
}
