//
//  Input+CoreDataProperties.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 31/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import Foundation
import CoreData


extension Input {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Input> {
        return NSFetchRequest<Input>(entityName: "Input")
    }

    @NSManaged public var inputInfo: NSObject?
    @NSManaged public var inputType: Int16
    @NSManaged public var mandatory: Int16

}
