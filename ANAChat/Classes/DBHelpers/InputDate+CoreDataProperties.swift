//
//  InputDate+CoreDataProperties.swift
//

import Foundation
import CoreData


extension InputDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InputDate> {
        return NSFetchRequest<InputDate>(entityName: "InputDate")
    }

    @NSManaged public var dateRange: DateRange?

}
