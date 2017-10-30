//
//  Simple+CoreDataProperties.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 31/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import Foundation
import CoreData


extension Simple {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Simple> {
        return NSFetchRequest<Simple>(entityName: "Simple")
    }

    @NSManaged public var mediaType: Int16
    @NSManaged public var mediaUrl: String?
    @NSManaged public var previewUrl: String?
    @NSManaged public var text: String?

}
