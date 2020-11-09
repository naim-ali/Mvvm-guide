//
//  PushNotificationCell.swift
//  Mvvm
//
//  Created by Naim Ali on 3/19/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit

class PushNotificationCell: UITableViewCell {

    var view: UIView!
    
    @IBOutlet var content: UIView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var favorited: UIImageView!
    
    var divider : UIView!
    
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
        
//        view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isUserInteractionEnabled = false
//        contentView.addSubview(view)
        
        storeName.textColor = Project.Colors.darkGreen
        storeName.textAlignment = .left
        storeName.font = UIFont(name: "Brandon Grotesque", size: 16.0)
        
//        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalEdgeInset).isActive = true
//        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalEdgeInset * -1.0).isActive = true
//        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalEdgeInset).isActive = true
//        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: verticalEdgeInset).isActive = true
        
        divider = UIView()
        
        // styles
        divider.backgroundColor = UIColor.lightGray
        
    }
    
    func getCellHeight() -> CGFloat {
        return 100.0
    }
    
    func AddConstraintsFor(divider: UIView, below viewOnTop: UIView)
    {
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        divider.topAnchor.constraint(equalTo: viewOnTop.bottomAnchor, constant: 5.0).isActive = true
        divider.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
