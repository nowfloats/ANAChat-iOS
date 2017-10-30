//
//  Options+CoreDataProperties.swift
//

import Foundation
import CoreData


extension Options {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Options> {
        return NSFetchRequest<Options>(entityName: "Options")
    }

    @NSManaged public var index: Int16
    @NSManaged public var title: String?
    @NSManaged public var value: String?
    @NSManaged public var type: Int16
    @NSManaged public var carouselItem: CarouselItem?
    @NSManaged public var inputTypeOptions: InputTypeOptions?

}
