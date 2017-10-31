//
//  optionsModel.swift
//

import UIKit

class OptionsModel: NSObject {
    var title : String!
    var value : String!
    var index : Int16!
    var type : Int16!
    
    override init (){
        super.init()
    }
    
    convenience init(_ dictionary: Dictionary<String, Any>, index : NSInteger, list: Bool?) {
        self.init()
        if let list = list{
            if  let title = dictionary[Constants.kTextKey] as? String, list == true {
                self.title = title
            }
        }else{
            if let title = dictionary[Constants.kTitleKey] as? String{
                self.title = title
            }
        }
        
        if let type = dictionary[Constants.kTypeKey] as? NSInteger{
            self.type = Int16(type)
        }
        
        if let value = dictionary[Constants.kValueKey] as? String{
            self.value = value
        }
        self.index = Int16(index)
    }
}
