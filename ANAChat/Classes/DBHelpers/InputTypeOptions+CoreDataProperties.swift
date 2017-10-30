//
//  InputTypeOptions+CoreDataProperties.swift
//

import Foundation
import CoreData


extension InputTypeOptions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InputTypeOptions> {
        return NSFetchRequest<InputTypeOptions>(entityName: "InputTypeOptions")
    }

    @NSManaged public var multiple: Int16
    @NSManaged public var options: NSSet?

}

// MARK: Generated accessors for options
extension InputTypeOptions {

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: Options)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: Options)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSSet)

}
