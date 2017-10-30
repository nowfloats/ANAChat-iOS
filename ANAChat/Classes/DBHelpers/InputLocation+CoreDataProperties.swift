//
//  InputLocation+CoreDataProperties.swift
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
