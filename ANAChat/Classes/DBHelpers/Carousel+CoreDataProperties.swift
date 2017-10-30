//
//  Carousel+CoreDataProperties.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 11/10/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//
//

import Foundation
import CoreData


extension Carousel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Carousel> {
        return NSFetchRequest<Carousel>(entityName: "Carousel")
    }

    @NSManaged public var inputInfo: NSObject?
    @NSManaged public var mandatory: Int16
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Carousel {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: CarouselItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: CarouselItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
