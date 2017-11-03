//
//  CarouselItem+CoreDataProperties.swift
//

import Foundation
import CoreData


extension CarouselItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarouselItem> {
        return NSFetchRequest<CarouselItem>(entityName: "CarouselItem")
    }

    @NSManaged public var desc: String?
    @NSManaged public var index: Int16
    @NSManaged public var mediaType: Int16
    @NSManaged public var mediaUrl: String?
    @NSManaged public var previewUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var mediaData: NSObject?
    @NSManaged public var carousel: Carousel?
    @NSManaged public var options: NSSet?

}

// MARK: Generated accessors for options
extension CarouselItem {

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: Options)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: Options)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSSet)

}
