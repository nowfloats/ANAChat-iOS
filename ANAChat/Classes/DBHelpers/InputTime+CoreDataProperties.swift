//
//  InputTime+CoreDataProperties.swift
//

import Foundation
import CoreData


extension InputTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InputTime> {
        return NSFetchRequest<InputTime>(entityName: "InputTime")
    }

    @NSManaged public var timeRange: TimeRange?

}
