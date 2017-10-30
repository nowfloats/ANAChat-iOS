//
//  InputDate+CoreDataProperties.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 31/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import Foundation
import CoreData


extension InputDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InputDate> {
        return NSFetchRequest<InputDate>(entityName: "InputDate")
    }

    @NSManaged public var dateRange: DateRange?

}
