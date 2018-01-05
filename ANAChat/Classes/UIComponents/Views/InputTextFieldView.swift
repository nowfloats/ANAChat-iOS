//
//  InputTextFieldView.swift
//

import UIKit

public class InputTextFieldView: UIView , UITextViewDelegate{
    
    @IBOutlet var inputBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var delegate: InputCellProtocolDelegate?
    var buttDict : NSDictionary = NSDictionary()
    var messageObject : Message!
    var placeHolderText : String?
    
    // MARK: -
    // MARK: UI Configuration Methods
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        let origImage = CommonUtility.getImageFromBundle(name: "msg_send")
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        inputBtn.setImage(tintedImage, for: .normal)
        inputBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 10, 12, 14)
        textView.tintColor = PreferencesManager.sharedInstance.getBaseThemeColor()
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 15)
    }
    
    public func configure(messageObject :Message?){
        self.textView.delegate = self
        placeHolderText = ""
        inputBtn.tintColor = UIColor.black.withAlphaComponent(0.1)
        self.textView.font = PreferencesManager.sharedInstance.getContentFont()
        if let messageObject = messageObject, messageObject.messageType == 2{
            self.messageObject = messageObject
            if let inputObject = messageObject as? Input{
                switch inputObject.inputType{
                case Int16(MessageInputType.MessageInputTypeText.rawValue):
                    if let inputTypeText = inputObject as? InputTypeText{
                        if let defaultString = inputTypeText.defaultText{
                            inputBtn.tintColor = PreferencesManager.sharedInstance.getBaseThemeColor()
                            self.textView.text = defaultString
                        }
                        if let placeHolder = inputTypeText.placeHolder {
                            if self.textView.text.count > 0{
                                textView.textColor = UIColor.black
                            }else{
                                textView.textColor = UIColor.lightGray
                                self.textView.text = placeHolder
                            }
                            placeHolderText = placeHolder
                        }
                        self.textView.keyboardType = .default
                        self.textView.autocapitalizationType = .sentences
                    }
                case Int16(MessageInputType.MessageInputTypeEmail.rawValue):
                    if let inputTypeText = inputObject as? InputTypeText{
                        if let defaultString = inputTypeText.defaultText{
                            self.textView.text = defaultString
                            inputBtn.tintColor = PreferencesManager.sharedInstance.getBaseThemeColor()

                        }
                        if let placeHolder = inputTypeText.placeHolder {
                            if self.textView.text.count > 0{
                                textView.textColor = UIColor.black
                            }else{
                                textView.textColor = UIColor.lightGray
                                self.textView.text = placeHolder
                            }
                            placeHolderText = placeHolder
                        }
                    }
                    self.textView.keyboardType = .emailAddress
                    self.textView.autocapitalizationType = .none
                case Int16(MessageInputType.MessageInputTypeNumeric.rawValue),Int16(MessageInputType.MessageInputTypePhone.rawValue):
                    self.textView.autocapitalizationType = .none

                    self.textView.keyboardType = .numberPad
                default:
                    break
                }
            }
        }else{
            self.messageObject = messageObject
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        let trimmedString = self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let fieldTextLength = trimmedString.count
        if fieldTextLength == 0 {
            self.sendAlertCallBack(alertText: "please enter proper text")
            return
        }
        
        if let messageObject = self.messageObject , messageObject.messageType == 2{
            if let inputObject = messageObject as? Input{
                switch inputObject.inputType{
                case Int16(MessageInputType.MessageInputTypeText.rawValue):
                    if inputObject.mandatory == 1{
                        if let inputTypeText = inputObject as? InputTypeText{
                            if inputTypeText.minLength > 0 ,inputTypeText.maxLength > 0{
                                if fieldTextLength < Int(inputTypeText.minLength) {
                                    self.sendAlertCallBack(alertText: AlertTexts.kMinimumLengthAlert)
                                }
                                if fieldTextLength > Int(inputTypeText.maxLength) {
                                    self.sendAlertCallBack(alertText: AlertTexts.kMaximumLengthAlert)
                                }
                                if  fieldTextLength >= Int(inputTypeText.minLength) && fieldTextLength <= Int(inputTypeText.maxLength){
                                    let inputDict = [Constants.kInputKey: [Constants.kValKey: self.textView.text]]
                                    self.sendTextCallBack(inputDict: inputDict)
                                }
                            }else{
                                let inputDict = [Constants.kInputKey: [Constants.kValKey: self.textView.text]]
                                self.sendTextCallBack(inputDict: inputDict)
                            }
                        }
                    }else if inputObject.mandatory == 0{
                        if let inputTypeText = inputObject as? InputTypeText{
                            
                            if  fieldTextLength > Int(inputTypeText.minLength) && fieldTextLength < Int(inputTypeText.maxLength){
                                let inputDict = [Constants.kInputKey: [Constants.kValKey: self.textView.text]]
                                self.sendTextCallBack(inputDict: inputDict)
                            }else{
                                let inputDict = [Constants.kInputKey: [Constants.kInputKey: self.textView.text]]
                                self.sendTextCallBack(inputDict: inputDict)
                            }
                        }
                    }
                case Int16(MessageInputType.MessageInputTypeEmail.rawValue):
                    if inputObject.mandatory == 1{
                        if (self.textView.text?.isValidEmail())! {
                            let inputDict = [Constants.kInputKey: [Constants.kValKey: self.textView.text]]
                            self.sendTextCallBack(inputDict: inputDict)
                        }else{
                            self.sendAlertCallBack(alertText: AlertTexts.kEmailAlert)
                        }
                    }else if inputObject.mandatory == 0{
                        if (self.textView.text?.isValidEmail())! {
                            let inputDict = [Constants.kInputKey: [Constants.kValKey: self.textView.text]]
                            self.sendTextCallBack(inputDict: inputDict)
                        }else{
                            let inputDict = [Constants.kInputKey: [Constants.kInputKey: self.textView.text]]
                            self.sendTextCallBack(inputDict: inputDict)
                        }
                    }
                case Int16(MessageInputType.MessageInputTypeNumeric.rawValue):
                    let inputDict = [Constants.kInputKey: [Constants.kValKey: self.textView.text]]
                    self.sendTextCallBack(inputDict: inputDict)
                case Int16(MessageInputType.MessageInputTypePhone.rawValue):
                    if inputObject.mandatory == 1{
                        if (self.textView.text?.isValidPhoneNumber)! {
                            let inputDict = [Constants.kInputKey: [Constants.kValKey: self.textView.text]]
                            self.sendTextCallBack(inputDict: inputDict)
                        }else{
                            self.sendAlertCallBack(alertText: AlertTexts.kPhoneNumberAlert)
                        }
                    }else{
                        if (self.textView.text?.isValidPhoneNumber)! {
                            let inputDict = [Constants.kInputKey: [Constants.kValKey: self.textView.text]]
                            self.sendTextCallBack(inputDict: inputDict)
                        }else{
                            let inputDict = [Constants.kInputKey: [Constants.kInputKey: self.textView.text]]
                            self.sendTextCallBack(inputDict: inputDict)
                        }
                    }
                default:
                    let inputDict = [Constants.kInputKey: [Constants.kInputKey: self.textView.text]]
                    self.delegate?.didTappedOnInputCell?(inputDict, messageObject: self.messageObject)
                    break
                }
            }
        }else{
            let inputDict = [Constants.kInputKey: [Constants.kInputKey: self.textView.text]]
            self.delegate?.didTappedOnInputCell?(inputDict, messageObject: self.messageObject)
        }
    }
    
    func sendTextCallBack(inputDict : [String: Any]) {
        self.delegate?.didTappedOnInputCell?(inputDict, messageObject: self.messageObject)
    }
    
    func sendAlertCallBack(alertText : String){
        self.delegate?.showAlert?(alertText)
    }
    
    // MARK: -
    // MARK: UITextViewDelegate Methods
     public func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == self.placeHolderText){
            textView.text = ""
            textView.textColor = .black
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView){
        if (textView.text == ""){
            textView.text = self.placeHolderText
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }

    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        let totalText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        let fieldTextLength = totalText.count
        if fieldTextLength > 0 {
            inputBtn.tintColor = PreferencesManager.sharedInstance.getBaseThemeColor()
            self.inputBtn.isUserInteractionEnabled = true
        }else{
            inputBtn.tintColor = UIColor.black.withAlphaComponent(0.1)
            self.inputBtn.isUserInteractionEnabled = false
        }
        
        let parastyle:NSMutableParagraphStyle =  NSMutableParagraphStyle()
        parastyle.lineBreakMode = .byWordWrapping
        
        #if swift(>=4.0)
            let rect: CGRect = totalText.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 90, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: PreferencesManager.sharedInstance.getContentFont(),NSAttributedStringKey.paragraphStyle:parastyle], context: nil)
            
            self.delegate?.configureTextViewHeight?(max(min(rect.size.height + 30 , 125),CGFloat(CellHeights.textInputViewHeight)))
        #else
            let rect: CGRect = totalText.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 90, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: PreferencesManager.sharedInstance.getContentFont(),NSParagraphStyleAttributeName:parastyle], context: nil)
            
            self.delegate?.configureTextViewHeight?(max(min(rect.size.height + 30 , 125),CGFloat(CellHeights.textInputViewHeight)))
        #endif
        
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder()
        return true
    }
    
    
}
