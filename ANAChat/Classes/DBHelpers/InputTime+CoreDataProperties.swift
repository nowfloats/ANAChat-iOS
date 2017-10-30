//
//  InputTime+CoreDataProperties.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 31/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import Foundation
import CoreData


extension InputTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InputTime> {
        return NSFetchRequest<InputTime>(entityName: "InputTime")
    }

    @NSManaged public var timeRange: TimeRange?

}
