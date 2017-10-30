//
//  External+CoreDataProperties.swift
//

import Foundation
import CoreData


extension External {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<External> {
        return NSFetchRequest<External>(entityName: "External")
    }

    @NSManaged public var contentJson: NSObject?

}
