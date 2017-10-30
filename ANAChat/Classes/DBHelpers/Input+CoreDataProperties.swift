//
//  Input+CoreDataProperties.swift
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
