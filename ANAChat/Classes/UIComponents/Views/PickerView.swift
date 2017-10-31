//
//  PickerView.swift
//

import UIKit

var PickerViewCellHeight = CGFloat(250)

class PickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource{

    var dict : NSDictionary = NSDictionary()
    var itemsDataArr : NSArray = NSArray()
    var messageObject : Message!
    var delegate: InputCellProtocolDelegate?

    @IBOutlet var picker: UIPickerView!
    @IBOutlet var pickerLbl: UILabel!
    @IBOutlet var pickerBtn: UIButton!
    
    public func configure(messageObject :Message){
        picker.delegate = self
        picker.dataSource = self
        
        pickerBtn.setImage(CommonUtility.getImageFromBundle(name: "msg_send"), for: UIControlState.normal)
        pickerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        pickerBtn.addTarget(self, action: #selector(didSelectItemFromList(sender:)), for: .touchUpInside)
        
        pickerLbl.layer.cornerRadius = 5.0
        pickerLbl.layer.masksToBounds = true
        
        self.messageObject = messageObject
        if let messageObject = self.messageObject, self.messageObject.messageType == 2{
            if let inputObject = messageObject as? InputTypeOptions{
                if let options = inputObject.options,(inputObject.options?.count)! > 0{
                    let sortDescriptor = NSSortDescriptor(key: Constants.kIndexKey, ascending: true)
                    let sortedOptions = options.sortedArray(using: [sortDescriptor])
                    self.itemsDataArr = sortedOptions as NSArray
                    
                    let optionsObject = self.itemsDataArr[0] as? Options
                    pickerLbl.text = String(format: "%@", (optionsObject?.title)!)
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.itemsDataArr.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let optionsObject = self.itemsDataArr[row] as? Options
        let pickerStr : String = String(format: "%@", (optionsObject?.title)!)
        return pickerStr
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let optionsObject = self.itemsDataArr[row] as? Options
        let pickerStr : String = String(format: "%@", (optionsObject?.title)!)
        pickerLbl.text = pickerStr
        
        print(pickerStr)
    }

    @objc func didSelectItemFromList(sender: UIButton)
    {
        let selectedIndex = picker!.selectedRow(inComponent: 0)
        if  let optionsObject = self.itemsDataArr[selectedIndex] as? Options{
            let inputDict = [Constants.kInputKey: [Constants.kValKey: optionsObject.value]]
            delegate?.didTappedOnInputCell?(inputDict, messageObject: self.messageObject)
        }
    }
}
