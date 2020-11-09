//
//  HomeViewController.swift
//  Mvvm
//
//  Created by Sean Davis on 12/6/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import Bond
import UIKit

protocol HomeViewControllerDelegate: BaseNavigationViewControllerDelegate {
    func shopSelected(homeViewController: HomeViewController, shopId: NSNumber?)
}

class HomeViewController: BaseNavigationViewController, UITableViewDelegate, UIScrollViewDelegate {
    
    weak var coordinator: HomeViewControllerDelegate? {
        didSet {
            super.baseNavigationCoordinator = coordinator
        }
    }
    var viewModel: HomeViewModel?
    
    var hotlightColor: UIColor = UIColor(red: 208.0 / 255.0, green: 31.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
    var locationColor: UIColor = UIColor.white
    var normalTextTitleColor: UIColor = UIColor(red: 11.0 / 255.0, green: 105.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    var highlightedTextTitleColor: UIColor = UIColor.white
    var normalTextDescriptionColor = UIColor(red: 126.0 / 255.0, green: 126.0 / 255.0, blue: 126.0 / 255.0, alpha: 1.0)
    var highlightedTextDescriptionColor = UIColor.white
    
    @IBOutlet weak var promotionImageView: UIImageView!
    @IBOutlet weak var myShopRow: UIView!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var driveThruLabel: UILabel!
    @IBOutlet weak var driveThruLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var myshopLabel: UILabel!
    @IBOutlet weak var myShopImage: UIImageView!
    @IBOutlet weak var myShopLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rewardsLabel: UILabel!
    @IBOutlet weak var rewardsTextView: TextView!
    
    @IBOutlet weak var feedContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var myShopRowHeight: NSLayoutConstraint!
    @IBOutlet weak var separatorViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rewardRow: UIView!
    @IBOutlet weak var rewardRowHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets bottom red button in super class
        self.setupMainButton()
        
        _ = viewModel?.errorMessages.observeNext { error in
            DispatchQueue.main.async() {
                let alertController = UIAlertController(title: "Oh no!", message: error, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                let actionOk = UIAlertAction(title: "OK", style: .default,
                                             handler: { action in alertController.dismiss(animated: true, completion: nil) })
                
                alertController.addAction(actionOk)
            }
        }
        
        _ = viewModel?.image.url.observeNext { value in
            DispatchQueue.global(qos: .background).async {
                if let url = URL(string: value) {
                    if let imageData = try? Data(contentsOf: url) {
                        DispatchQueue.main.async() {
                            self.promotionImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
        
        _ = viewModel?.authentication.value.favoriteShop.observeNext { value in
            DispatchQueue.main.async() {
                self.locationLabel.text = value?.shopName
                self.openLabel.text = value?.hoursDescriptionDineIn
                self.driveThruLabel.text = value?.hoursDescriptionDriveThru
                self.loadHotlightView(hotlightOn: value?.hotLightOn == 1)
                
                if (self.viewModel?.authentication.value.isAuthorized)! {
                    self.loadUserView()
                } else {
                    self.loadGuestView()
                }
            }
        }
        
        _ = viewModel?.locationEnabled.observeNext { value in
            DispatchQueue.main.async() {
                if (!value) {
                    let myshopAttrStr = NSMutableAttributedString(string: "FIND A SHOP")
                    myshopAttrStr.addAttribute(.kern, value: CGFloat(1.1), range: NSMakeRange(0, myshopAttrStr.length))
                    self.myshopLabel.attributedText = myshopAttrStr
                    self.locationLabel.text = "Choose your favorite!"
                }
            }
        }
        
        _ = viewModel?.rewards.observeNext { value in
            DispatchQueue.main.async() {
                self.rewardsTextView.text = ""
                for reward in value.source.array {
                    self.rewardsTextView.text = self.rewardsTextView.text + reward + "\n"
                }
            }
        }
        
        let width = Int(UIScreen.main.scale * myShopImage.frame.width)
        let height = Int(UIScreen.main.scale * myShopImage.frame.height)
        viewModel?.getImage(width: width, height: height)
        viewModel?.getMyShop()
        
        myShopRow.addTapGestureRecognizer {
            self.coordinator?.shopSelected(homeViewController: self, shopId: self.viewModel?.authentication.value.favoriteShop.value?.shopId)
        }
    }
    
    private func loadGuestView() {
        let myshopAttrStr = NSMutableAttributedString(string: "SHOP NEAR ME")
        myshopAttrStr.addAttribute(.kern, value: CGFloat(1.1), range: NSMakeRange(0, myshopAttrStr.length))
        myshopLabel.attributedText = myshopAttrStr
        
        rewardRow.isHidden = true
        feedContainerHeight.constant = myShopRowHeight.constant + separatorViewHeight.constant
        
        currentMainButtonTag = NavigationButtonTag.signUpForRewards
    }
    
    private func loadUserView() {
        let myshopAttrStr = NSMutableAttributedString(string: "MY SHOP")
        myshopAttrStr.addAttribute(.kern, value: CGFloat(1.1), range: NSMakeRange(0, myshopAttrStr.length))
        myshopLabel.attributedText = myshopAttrStr
        
        rewardRow.isHidden = true
        feedContainerHeight.constant = myShopRowHeight.constant + separatorViewHeight.constant
        
        /* LATER
        rewardRow.isHidden = false
        let rewardsAttrStr = NSMutableAttributedString(string: "REWARDS")
        rewardsAttrStr.addAttribute(.kern, value: CGFloat(1.1), range: NSMakeRange(0, rewardsAttrStr.length))
        rewardsLabel.attributedText = rewardsAttrStr
        
        viewModel?.getRewards()
        
        feedContainerHeight.constant = myShopRowHeight.constant + separatorViewHeight.constant + rewardRowHeight.constant
        */
        
        currentMainButtonTag = NavigationButtonTag.myRewards
    }
    
    func loadHotlightView(hotlightOn: Bool) {
        if(hotlightOn) {
            myShopRow.backgroundColor = hotlightColor
            openLabel.textColor = UIColor.white
            driveThruLabel.textColor = UIColor.white
            locationLabel.textColor = UIColor.white
            myshopLabel.textColor = UIColor.white
            myShopImage.image = UIImage(named: "White Shop Location Icon")
        } else {
            myShopRow.backgroundColor = UIColor.white
            let isClosed = viewModel?.authentication.value.favoriteShop.value?.isClosed == 1
            openLabel.textColor = isClosed ? UIColor.red : normalTextDescriptionColor
            driveThruLabel.textColor = normalTextDescriptionColor
            locationLabel.textColor = normalTextDescriptionColor
            myshopLabel.textColor = normalTextTitleColor
            myShopImage.image = UIImage(named: "Location Icon")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
