//
//  Addressview.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 30/09/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

class AddressView: UIView,UIGestureRecognizerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var buildingNumberTextField: UITextField!
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var localityTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var pincodeTextField: UITextField!
    @IBOutlet weak var sendAddressButton: UIButton!
    @IBOutlet weak var viewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    var messageObject : InputAddress!

    var delegate: InputCellProtocolDelegate?

    override func awakeFromNib() {
        self.configureUI()
        self.addTapGestureRecognizer()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(x: self.frame.origin.x , y : 0,width: self.frame.size.width,height: self.frame.size.height)
        }
    }

    func configureUI(){
        self.cellContentView.layer.cornerRadius = 2.0
        self.cellContentView.layer.masksToBounds = true
        self.buildingNumberTextField.delegate = self
        self.streetNameTextField.delegate = self
        self.localityTextField.delegate = self;
        self.cityTextField.delegate = self;
        self.countryTextField.delegate = self;
        self.pincodeTextField.delegate = self;
        
        self.cityTextField.tag = 1
        self.countryTextField.tag = 2
        self.pincodeTextField.tag = 3
        
        if UIScreen.main.bounds.size.height == 480 {
            self.viewYConstraint.constant = -30;
        }else{
            self.viewYConstraint.constant = -50;
        }
        self.submitButton.layer.cornerRadius = 2.0
        self.submitButton.layer.masksToBounds = true
        self.submitButton.backgroundColor = PreferencesManager.sharedInstance.getBaseThemeColor()
    }
    
    public func configure(messageObject : InputAddress){
        self.messageObject = messageObject
    }
    
    func addTapGestureRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    // MARK: -
    // MARK: UITextFieldDelegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var cellOffSet = textField.tag*32

        if UIScreen.main.bounds.size.height == 480 {
            cellOffSet = textField.tag*60
        }
        
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(x: self.frame.origin.x , y : CGFloat(-cellOffSet),width: self.frame.size.width,height: self.frame.size.height)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(x: self.frame.origin.x , y : 0,width: self.frame.size.width,height: self.frame.size.height)
        }
       return true
    }
    
    func validateFields() -> Bool{
        var isValidFields = Bool()
        isValidFields = true
        if  self.messageObject.requiredFields != nil {
            if let requiredFields = self.messageObject.requiredFields as? NSArray{
                if requiredFields.contains("line1"){
                    if buildingNumberTextField.text!.isEmpty{
                        isValidFields = false
                    }
                }
                if requiredFields.contains("area"){
                    if streetNameTextField.text!.isEmpty{
                        isValidFields = false
                    }
                }
                if requiredFields.contains("locality"){
                    if localityTextField.text!.isEmpty{
                        isValidFields = false
                    }
                }
                if requiredFields.contains("city"){
                    if cityTextField.text!.isEmpty{
                        isValidFields = false
                    }
                }
                if requiredFields.contains("country"){
                    if countryTextField.text!.isEmpty{
                        isValidFields = false
                    }
                }
                if requiredFields.contains("pin"){
                    if countryTextField.text!.isEmpty{
                        isValidFields = false
                    }
                }
            }
        }
        return isValidFields
    }
    
    // MARK: -
    // MARK: IBAction Methods
    
    @IBAction func addressButtonTapped(_ sender: Any) {
        self.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(x: self.frame.origin.x , y : 0,width: self.frame.size.width,height: self.frame.size.height)
        }
        
        let validDetails = self.validateFields()
        if validDetails {
            var addressInfo = [String: Any]()
            if !buildingNumberTextField.text!.isEmpty{
                addressInfo["line1"] = buildingNumberTextField.text
            }
            if !streetNameTextField.text!.isEmpty{
                addressInfo["area"] = streetNameTextField.text
            }
            if !localityTextField.text!.isEmpty{
                addressInfo["locality"] = localityTextField.text
            }
            if !cityTextField.text!.isEmpty{
                addressInfo["city"] = cityTextField.text
            }
            if !countryTextField.text!.isEmpty{
                addressInfo["country"] = countryTextField.text
            }
            if !pincodeTextField.text!.isEmpty{
                addressInfo["pin"] = pincodeTextField.text
            }
            let inputDict = [Constants.kInputKey: ["address": addressInfo]]

            self.removeFromSuperview()
            self.delegate?.didTappedOnInputCell?(inputDict, messageObject: self.messageObject)
        }else{
            self.delegate?.showAlert?("Please enter valid address")
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
        self.delegate?.didTappedOnCloseCell?()
    }
    
}
