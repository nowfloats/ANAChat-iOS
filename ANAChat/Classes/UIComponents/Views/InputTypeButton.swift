//
//  InputMediaView.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 26/09/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

class InputTypeButton: UIView ,UIGestureRecognizerDelegate{
    
    var delegate: InputCellProtocolDelegate?
    var messageObject : Message!
    var options: [Any]?

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView?.layer.cornerRadius = 2.0
        contentView.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor()
        self.submitButton.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self 
        self.addGestureRecognizer(tap)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.sendCallBack()
    }
    
    public func configure(messageObject :Message){
        self.messageObject = messageObject
        
        if let inputTypeMedia = messageObject as? InputTypeMedia{
            switch inputTypeMedia.mediaType {
            case Int16(MessageSimpleType.MessageSimpleTypeImage.rawValue):
                self.submitButton.setTitle("Send Photo", for: .normal)
            case Int16(MessageSimpleType.MessageSimpleTypeVideo.rawValue):
                self.submitButton.setTitle("Send Video", for: .normal)
            case Int16(MessageSimpleType.MessageSimpleTypeFILE.rawValue):
                self.submitButton.setTitle("Upload File", for: .normal)
            default:
                break
            }
        }else if let _ = messageObject as? InputAddress{
            self.submitButton.setTitle("Send Address", for: .normal)
        }else if let _ = messageObject as? InputDate{
            self.submitButton.setTitle("Send Date", for: .normal)
        }else if let _ = messageObject as? InputTime{
            self.submitButton.setTitle("Send Time", for: .normal)
        }else if let _ = messageObject as? InputLocation{
            self.submitButton.setTitle("Send Location", for: .normal)
        }else if let _ = messageObject as? InputTypeOptions{
            self.submitButton.setTitle("Select List", for: .normal)
        }else if let input = messageObject as? Input{
            if input.inputType == Int16(MessageInputType.MessageInputTypeGetStarted.rawValue){
                self.submitButton.setTitle("Get Started", for: .normal)
            }
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        self.sendCallBack()
    }
    
    func sendCallBack(){
        if let inputTypeMedia = messageObject as? InputTypeMedia{
            switch inputTypeMedia.mediaType {
            case Int16(MessageSimpleType.MessageSimpleTypeImage.rawValue):
                delegate?.didTappedOnMediaCell?(messageObject)
            case Int16(MessageSimpleType.MessageSimpleTypeVideo.rawValue):
                delegate?.didTappedOnMediaCell?(messageObject)
            case Int16(MessageSimpleType.MessageSimpleTypeFILE.rawValue):
                delegate?.didTappedOnUploadFile?(messageObject)
            default:
                break;
            }
        }else if let _ = messageObject as? InputAddress{
            delegate?.didTappedOnAddressCell?(messageObject)
        }else if let _ = messageObject as? InputTypeOptions{
            delegate?.didTappedOnListCell?(messageObject)
       }else if let _ = messageObject as? InputDate{
            delegate?.didTappedOnSendDateCell?(messageObject)
        }else if let _ = messageObject as? InputTime{
            delegate?.didTappedOnSendDateCell?(messageObject)
        }else if let _ = messageObject as? InputLocation{
            self.delegate?.didTappedOnSendLocationCell?(self.messageObject)
        }else if let input = messageObject as? Input{
            if input.inputType == Int16(MessageInputType.MessageInputTypeGetStarted.rawValue){
                delegate?.didTappedOnGetStartedCell!(input)
            }
        }
    }
}
