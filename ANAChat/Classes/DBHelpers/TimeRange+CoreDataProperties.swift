//
//  TimeRange+CoreDataProperties.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 31/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import Foundation
import CoreData


extension TimeRange {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeRange> {
        return NSFetchRequest<TimeRange>(entityName: "TimeRange")
    }

    @NSManaged public var interval: String?
    @NSManaged public var maxHour: String?
    @NSManaged public var maxMinute: String?
    @NSManaged public var maxSecond: String?
    @NSManaged public var minHour: String?
    @NSManaged public var minMinute: String?
    @NSManaged public var minSecond: String?
    @NSManaged public var inputTime: InputTime?

}
