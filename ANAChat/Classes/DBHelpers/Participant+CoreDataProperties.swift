//
//  Participant+CoreDataProperties.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 19/09/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import Foundation
import CoreData


extension Participant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Participant> {
        return NSFetchRequest<Participant>(entityName: "Participant")
    }

    @NSManaged public var id: String?
    @NSManaged public var medium: Int16
    @NSManaged public var senderMessage: Message?
    @NSManaged public var recipientMessage: Message?

}
