//
//  RewardsViewController.swift
//  Mvvm
//
//  Created by Sean Davis on 12/6/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class RewardsViewController: BaseNavigationViewController {
/*
    var rewardsService: IRewardsService?
    
    var rewards: [Reward]! = [Reward]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var balanceContainer: UIView!
    @IBOutlet weak var addFundsButton: UIButton!
    @IBOutlet weak var earnedRewardsTitle: UILabel!
    @IBOutlet weak var disclaimerText: UILabel!
    @IBOutlet weak var earnedRewardsContainer: UIView!
    @IBOutlet weak var cardBalance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //TODO: currentMainButtonTag = NavigationButtonTag.rewardsProgress

        rewardsService = TestRewardsService()
        
        let d1 = Reward()
        d1.name = "Doughnut"
        let d2 = Reward()
        d2.name = "Doughnut"
        
        rewards.append(d1)
        rewards.append(d2)
        
        initUI()
        
    }

    private func initUI() {
        
        addFundsButton.layer.cornerRadius = 22.0
        addFundsButton.layer.shadowColor = UIColor.lightGray.cgColor
        addFundsButton.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        addFundsButton.layer.masksToBounds = false
        addFundsButton.layer.shadowRadius = 14.0
        addFundsButton.layer.shadowOpacity = 0.5
        
        let addFundsAttrStr = NSMutableAttributedString(string: "ADD FUNDS")
        addFundsAttrStr.addAttribute(.kern, value: CGFloat(1.0), range: NSMakeRange(0, addFundsAttrStr.length))
        addFundsAttrStr.addAttribute(.foregroundColor, value: Project.Colors.darkGreen, range: NSMakeRange(0, addFundsAttrStr.length))
        addFundsButton.setAttributedTitle(addFundsAttrStr, for: .normal)
        
        let earnedRewAttrStr = NSMutableAttributedString(string: "EARNED REWARDS")
        earnedRewAttrStr.addAttribute(.kern, value: CGFloat(1.0), range: NSMakeRange(0, earnedRewAttrStr.length))
        earnedRewardsTitle.attributedText = earnedRewAttrStr
        
        let cardBalAttrStr = NSMutableAttributedString(string: "CARD BALANCE")
        cardBalAttrStr.addAttribute(.kern, value: CGFloat(0.9), range: NSMakeRange(0, cardBalAttrStr.length))
        cardBalance.attributedText = cardBalAttrStr

        var previousView:UIView! = earnedRewardsTitle
        for type in ["Dozen", "Drink", "Doughnut", "Coffee"] {
            let label = renderLabelFor(rewardType: type, underView: previousView, inContainer: earnedRewardsContainer)
            if label != nil {
                previousView = label
            }
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        let attrString = NSMutableAttributedString(string: "Rewards will be available during checkout or after scanning your card in shop.")
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        disclaimerText.attributedText = attrString
        disclaimerText.translatesAutoresizingMaskIntoConstraints = false
        disclaimerText.numberOfLines = 0
        disclaimerText.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 15.0).isActive = true
    }
    
    private func renderLabelFor(rewardType type: String, underView previousView: UIView, inContainer container:UIView) -> UIView? {
        let rewardsOfType = rewards.filter { $0.name == type }
        if !rewardsOfType.isEmpty {
            let rewardLabel = UILabel()
            let plural = rewardsOfType.count > 1 ? "s" : ""
            rewardLabel.text = "\(rewardsOfType.count) Free \(type)\(plural)"
            rewardLabel.translatesAutoresizingMaskIntoConstraints = false
            rewardLabel.font = UIFont(name: "FrutigerLTCom-Roman", size: 15.0)
            rewardLabel.textColor = UIColor(red: 126.0 / 255.0, green: 126.0 / 255.0, blue: 126.0 / 255.0, alpha: 1.0)
            container.addSubview(rewardLabel)
            
            rewardLabel.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 10.0).isActive = true
            rewardLabel.leadingAnchor.constraint(equalTo: previousView.leadingAnchor).isActive = true
            rewardLabel.trailingAnchor.constraint(equalTo: previousView.trailingAnchor).isActive = true
            return rewardLabel
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addFundsTapped(_ sender: Any) {
        if let addPaymentsController = UIStoryboard(name: "RewardsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "addPaymentMethodViewController") as? AddPaymentMethodTableViewController {
            addPaymentsController.paymentMethods = (UIApplication.shared.delegate as! AppDelegate).userPaymentMethods
            navigationController?.pushViewController(addPaymentsController, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
 
*/
}
