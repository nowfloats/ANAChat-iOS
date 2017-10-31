//
//  InputMediaModel.swift
//

import UIKit

class InputMediaModel: NSObject {
    var mediaType : Int16!

    override init (){
        super.init()
    }
    
    convenience init(_ dictionary: Dictionary<String, Any>) {
        self.init()
        if let mediaType = dictionary[Constants.kMediaTypeKey] as? NSInteger{
            self.mediaType = Int16(mediaType)
        }
    }
}
