//
//  ChatReceiveTextCell.swift
//  RiaChatSDK
//
//  Created by Madhu on 24/07/17.
//  Copyright © 2017 Mine. All rights reserved.
//

import UIKit

class ChatReceiveTextCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var textLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var cellViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var paddingImageView: UIImageView!
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var arrowViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    var shape = CAShapeLayer()
    var maskLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        paddingImageView.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor()
        // Initialization code for long gesture recognizer
        /*
        let longPressRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGestureRecognizer:)))
        self.contentView.addGestureRecognizer(longPressRecognizer)
        */
        cellBackgroundView?.layer.cornerRadius = 10.0
        self.arrowView.backgroundColor = UIColor.clear
        textLbl?.font = PreferencesManager.sharedInstance.getContentFont()
        timeLbl?.font = UIConfigurationUtility.Fonts.TimeLblFont
        timeLbl?.alpha = 0.5
        
        let trianglePath = CGMutablePath()
        trianglePath.move(to: CGPoint(x: 0, y: 0))
        trianglePath.addLine(to: CGPoint(x: 19, y: 0))
        trianglePath.addLine(to: CGPoint(x: 19, y: 16))
        trianglePath.addLine(to: CGPoint(x: 0, y: 0))
        
        shape.frame = self.arrowView.bounds
        shape.path = trianglePath
        shape.lineWidth = 2.0
        shape.strokeColor = PreferencesManager.sharedInstance.getBaseThemeColor().cgColor
        shape.fillColor = PreferencesManager.sharedInstance.getBaseThemeColor().cgColor
        self.arrowView.layer.insertSublayer(shape, at: 0)
        
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.shadowOffset = CGSize(width : 0, height : 2)
        self.shadowView.layer.shadowRadius = 2
        self.shadowView.layer.shadowOpacity = 1.0
        self.shadowView.layer.shadowColor = UIColor.init(hexString: "#6E6E6E").withAlphaComponent(0.35).cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func configureView(_ simple:Simple, showArrow : Bool){
        if let text = simple.text{
            self.textLbl.text = text
        }
        if let messageTimeStamp = simple.timestamp{
            self.timeLbl.text = CommonUtility.getTimeString(messageTimeStamp)
        }else{
            self.timeLbl.text = ""
        }
        if showArrow {
            self.arrowViewHeightConstraint.constant = 16
        }else{
            self.arrowViewHeightConstraint.constant = 0
        }
    }
    
    // MARK: -
    // MARK: Fetched UILongPressGestureRecognizer Helper Methods
    func handleLongPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            print("long press detected")
            // your code here, get the row for the indexPath or do whatever you want
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
