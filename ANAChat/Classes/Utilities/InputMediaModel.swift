//
//  InputMediaModel.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 26/09/17.
//  Copyright © 2017 NowFloats. All rights reserved.
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
