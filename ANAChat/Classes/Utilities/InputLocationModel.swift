//
//  InputLocationModel.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 24/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

class InputLocationModel: NSObject {
    var latitude : String!
    var longitude : String!
    
    override init ()
    {
        super.init()
    }
    
    convenience init(_ dictionary: Dictionary<String, Any>) {
        self.init()
        if let latitude = dictionary[Constants.kLatitudeKey] as? NSNumber{
            self.latitude = String(format:"%f", latitude.doubleValue)
        }
        if let longitude = dictionary[Constants.kLongitudeKey] as? NSNumber{
            self.longitude = String(format:"%f", longitude.doubleValue)
        }
    }
}
