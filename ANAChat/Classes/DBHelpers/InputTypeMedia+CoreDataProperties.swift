//
//  InputTypeMedia+CoreDataProperties.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 26/09/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//
//

import Foundation
import CoreData


extension InputTypeMedia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InputTypeMedia> {
        return NSFetchRequest<InputTypeMedia>(entityName: "InputTypeMedia")
    }

    @NSManaged public var mediaType: Int16

}
