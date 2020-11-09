//
//  RewardsProgressViewController.swift
//  Mvvm
//
//  Created by Sean Davis on 12/7/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class RewardsProgressViewController: UITableViewController {
/*
    var rewards:[Reward]! = [Reward]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .clear

        
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.row)
        {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rewardProgressHeader", for: indexPath) as! RewardsProgressSectionTableViewCell

            let attrString = NSMutableAttributedString(string: "REWARDS Progress")
            let firstHalf: [NSAttributedStringKey: Any] = [.font: UIFont(name: "Brandon Grotesque", size: 20.0)! as Any,
                                                         .foregroundColor: UIColor(red: 11.0 / 255.0, green: 105.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0) as Any]
            let secondHalf: [NSAttributedStringKey: Any] = [.font: UIFont(name: "ClaudeSansStd-BoldItalic", size: 24.0)! as Any,
                                                            .foregroundColor: UIColor(red: 208.0 / 255.0, green: 31.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0) as Any]
            attrString.addAttributes(firstHalf, range: NSMakeRange(0, 7))
            attrString.addAttributes(secondHalf, range: NSMakeRange(8, attrString.length - 8))
            attrString.addAttribute(.kern, value: CGFloat(2.1), range: NSMakeRange(0,7))
            cell.titleLabel.attributedText = attrString
            
            // hide separator
            cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0)
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rewardProgressCell", for: indexPath) as! RewardsProgressTableViewCell
            
            let reward:Reward = rewards[indexPath.row - 1]
            cell.rewardImage?.image = reward.image
            let progressPercent:CGFloat = CGFloat(reward.userProgress) / CGFloat(reward.rewardRequirement) * 100
            cell.circularProgressView.value = progressPercent
            
            let progressAttrStr = NSMutableAttributedString(string: "\(reward.userProgress!)/\(reward.rewardRequirement!)")
            progressAttrStr.addAttribute(.kern, value: CGFloat(1.1), range: NSMakeRange(0, progressAttrStr.length))
            cell.progressLabel.attributedText = progressAttrStr
            
            let rewardDescAttrStr = NSMutableAttributedString(string: "\(reward.rewardRequirement! - reward.userProgress!) MORE FOR A FREE \(reward.name!.uppercased())!")
            rewardDescAttrStr.addAttribute(.kern, value: CGFloat(1.1), range: NSMakeRange(0, rewardDescAttrStr.length))
            cell.rewardDescriptionLabel.attributedText = rewardDescAttrStr
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewards.count + 1 // header
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row)
        {
        case 0:
            return 100.0
        default:
            return 361.0
        }
    }
    */
}
