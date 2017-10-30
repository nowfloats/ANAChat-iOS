//
//  InputAddress+CoreDataProperties.swift
//

import Foundation
import CoreData


extension InputAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InputAddress> {
        return NSFetchRequest<InputAddress>(entityName: "InputAddress")
    }

    @NSManaged public var requiredFields: NSObject?

}
