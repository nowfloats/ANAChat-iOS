//
//  ParticipantModel.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 19/09/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

class ParticipantModel: NSObject {
    var id : String!
    var medium: Int16!
    
    
    override init (){
        super.init()
    }
    
    convenience init(_ dictionary: Dictionary<String, Any>) {
        self.init()
        if let senderType = dictionary[Constants.kMediumKey] as? NSInteger{
            self.medium = Int16(senderType)
        }
        if let id = dictionary[Constants.kIdKey] as? String{
            self.id = id
        }
    }
    
}
