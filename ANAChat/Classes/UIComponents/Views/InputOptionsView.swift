//
//  ButtonsView.swift
//  RiaChatSDK
//
//  Created by Madhu on 27/07/17.
//  Copyright © 2017 Mine. All rights reserved.
//

import UIKit

var OptionsViewCellHeight = CGFloat(CellHeights.optionsViewCellHeight)
var OptionsTopPadding = CGFloat(10)

class InputOptionsView: UIView{
    
    var delegate: InputCellProtocolDelegate?
    var buttonArr : NSArray = NSArray()
    var messageObject : Message!

    @IBOutlet weak var scrollLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var buttonsScroll: UIScrollView!

    public func configure(messageObject :Message){
        self.messageObject = messageObject
        if let messageObject = self.messageObject, self.messageObject.messageType == 2{
            if let inputObject = messageObject as? InputTypeOptions{
                if let options = inputObject.options{
                    let sortDescriptor = NSSortDescriptor(key: Constants.kIndexKey, ascending: true)
                    let sortedOptions = options.sortedArray(using: [sortDescriptor])
                    self.buttonsScroll.subviews.forEach { $0.removeFromSuperview() }
                    buttonArr = sortedOptions as NSArray
                    print(sortedOptions)
                    
                    self.buttonsScroll.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: OptionsViewCellHeight)
                    var XPos : CGFloat = 20.0
                    
                    for index in 0 ..< buttonArr.count{
                        
                        let optionsObject = buttonArr[index] as? Options
                        let nextNodeButton = UIButton()
                        nextNodeButton.frame = CGRect(x: Int(XPos), y:Int(OptionsTopPadding), width: 100, height: (Int(OptionsViewCellHeight - 2*OptionsTopPadding)))
                        nextNodeButton.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor()
                        nextNodeButton.setTitle(optionsObject?.title, for: .normal)
                        nextNodeButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
                        nextNodeButton.setTitleColor(UIColor.white, for: .normal)
                        nextNodeButton.tag = index+1
                        nextNodeButton.addTarget(self, action: #selector(didTappedOnOption(sender:)), for: .touchUpInside)
                        nextNodeButton.layer.cornerRadius = 5.0
                        self.buttonsScroll.addSubview(nextNodeButton)
                        
                        nextNodeButton.sizeToFit()
                        
                        nextNodeButton.frame = CGRect(x: XPos, y:OptionsTopPadding, width: (nextNodeButton.frame.size.width) + 35, height: OptionsViewCellHeight - OptionsTopPadding*2)
                        
                        XPos = nextNodeButton.frame.maxX+20
                        
                        if(XPos > self.frame.size.width){
                            self.buttonsScroll.contentSize = CGSize(width: XPos, height: OptionsViewCellHeight)
                            self.scrollLeadingConstraint.constant = 0
                        }else{
                            self.buttonsScroll.contentSize = CGSize(width: XPos, height: OptionsViewCellHeight)
                            self.scrollLeadingConstraint.constant = (DeviceUtils.ScreenSize.SCREEN_WIDTH - XPos)/2
                        }
                    }
                }
            }
        }
    }
    
    func didTappedOnOption(sender: UIButton){
        
        if  let optionsObject = self.buttonArr[sender.tag - 1] as? Options{
            if optionsObject.type == 0 {
                if let value = optionsObject.value{
                    let data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    do {
                        let messageDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                        
                        if let value = messageDictionary[Constants.kValueKey] as? String{
                            let inputDict = [Constants.kInputKey: [Constants.kValKey: value,Constants.kTextKey : optionsObject.title]]
                            delegate?.didTappedOnInputCell?(inputDict, messageObject: self.messageObject)
                        }
                        
                        if let url = messageDictionary[Constants.kUrlKey] as? String{
                            self.delegate?.didTappedOnOpenUrl?(url)
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                }
            }else{
                let inputDict = [Constants.kInputKey: [Constants.kValKey: optionsObject.value, Constants.kTextKey : optionsObject.title]]
                delegate?.didTappedOnInputCell?(inputDict, messageObject: self.messageObject)
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
