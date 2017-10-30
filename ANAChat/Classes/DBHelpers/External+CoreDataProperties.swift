//
//  External+CoreDataProperties.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 31/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import Foundation
import CoreData


extension External {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<External> {
        return NSFetchRequest<External>(entityName: "External")
    }

    @NSManaged public var contentJson: NSObject?

}
