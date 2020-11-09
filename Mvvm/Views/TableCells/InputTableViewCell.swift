//
//  InputTableViewCell.swift
//  Sagepath
//
//  Created by Sean Davis on 12/5/17.
//  Copyright © 2017 Sean Davis. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell {
    
    var view: UIView!
    var label: UILabel!
    var divider: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit()
    {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        let horizontalEdgeInset: CGFloat = 30.0
        let verticalEdgeInset: CGFloat = 20.0
        
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalEdgeInset * -1.0).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalEdgeInset).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: verticalEdgeInset).isActive = true
    
        label = UILabel()
        
        divider = UIView()
        
        // styles
        
        label.textColor = UIColor(red: 35.0 / 255.0, green: 86.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)
        label.font = UIFont(name: "TrebuchetMS-Bold", size: 18.0)
        
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

}
