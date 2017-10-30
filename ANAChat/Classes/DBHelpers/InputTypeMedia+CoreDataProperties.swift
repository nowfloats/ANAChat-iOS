//
//  InputTypeMedia+CoreDataProperties.swift
//

import Foundation
import CoreData


extension InputTypeMedia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InputTypeMedia> {
        return NSFetchRequest<InputTypeMedia>(entityName: "InputTypeMedia")
    }

    @NSManaged public var mediaType: Int16

}
