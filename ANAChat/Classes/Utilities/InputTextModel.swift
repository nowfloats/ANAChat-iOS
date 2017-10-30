//
//  InputTextModel.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 24/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

class InputTextModel: NSObject {
    var multiLine : Int16!
    var minLength : Int32!
    var maxLength : Int32!
    var defaultText : String!
    var placeHolder : String!
    
    override init ()
    {
        super.init()
    }
    
    convenience init(_ dictionary: Dictionary<String, Any>) {
        self.init()
        if let multiLine = dictionary[Constants.kMultiLineKey] as? NSInteger{
            self.multiLine = Int16(multiLine)

        }
        if let minLength = dictionary[Constants.kMinLengthKey] as? NSInteger{
            self.minLength = Int32(minLength)
        }
        if let maxLength = dictionary[Constants.kMaxLengthKey] as? NSInteger{
            self.maxLength = Int32(maxLength)
        }
        if let defaultText = dictionary[Constants.kDefaultTextKey] as? String{
            self.defaultText = defaultText
        }
        if let placeHolder = dictionary[Constants.kPlaceHolderKey] as? String{
            self.placeHolder = placeHolder
        }
    }
}
