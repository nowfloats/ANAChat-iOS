//
//  InputAddress+CoreDataProperties.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 30/09/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//
//

import Foundation
import CoreData


extension InputAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InputAddress> {
        return NSFetchRequest<InputAddress>(entityName: "InputAddress")
    }

    @NSManaged public var requiredFields: NSObject?

}
