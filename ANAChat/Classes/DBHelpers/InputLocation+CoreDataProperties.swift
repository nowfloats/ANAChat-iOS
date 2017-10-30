//
//  InputLocation+CoreDataProperties.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 31/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import Foundation
import CoreData


extension InputLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InputLocation> {
        return NSFetchRequest<InputLocation>(entityName: "InputLocation")
    }

    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?

}
