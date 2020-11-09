//
//  LocationCell.swift
//  Mvvm
//
//  Created by Naim Ali on 3/7/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit
import MaterialComponents

class LocationCell: UITableViewCell {
    
    var inkTouchController : MDCInkTouchController!
    var view: UIView!
    
    @IBOutlet var content: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var openHours: UILabel!
    @IBOutlet weak var driveThruHours: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var province: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var hotlight: UIButton!
    @IBOutlet weak var toggleLikeBtn: UIButton!
    @IBOutlet weak var toggleLikeBtnWidth: NSLayoutConstraint!
    var divider: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit()
    {
        self.selectionStyle = .none;
        
        inkTouchController = MDCInkTouchController(view: self)
        inkTouchController.addInkView()
        
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        contentView.addSubview(view)
        
        storeName.textColor = Project.Colors.darkGreen
        storeName.textAlignment = .left
    }
}

