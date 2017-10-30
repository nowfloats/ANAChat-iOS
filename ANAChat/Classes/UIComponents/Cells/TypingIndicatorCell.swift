//
//  TypingIndicatorCell.swift
//  RiaChatSDK
//
//  Created by Madhu on 26/07/17.
//  Copyright © 2017 Mine. All rights reserved.
//

import UIKit

var TypingIndicatorCellHeight = CGFloat(CellHeights.typingIndicatorViewHeight)

class TypingIndicatorCell: UITableViewCell {

    var typingView: TypingIndicatorView!

    @IBOutlet weak var paddingView: UIView!
    @IBOutlet var IndicatorView: UIView!
    @IBOutlet var IndicatorViewLeadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpSubViews()
        // Initialization code
        self.backgroundColor = UIColor.clear
        paddingView.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor()
        self.IndicatorView.backgroundColor = UIColor.white
        IndicatorView?.layer.cornerRadius = 10.0
        IndicatorView.layer.masksToBounds = true
    }
    
    func setUpSubViews() {
        typingView = TypingIndicatorView.init(frame: CGRect(x: 5, y: 0, width: 50, height: TypingIndicatorCellHeight))
        self.IndicatorView.addSubview(typingView)
    }
    
    func showTyping(){
        typingView.showTyping()
    }
}
