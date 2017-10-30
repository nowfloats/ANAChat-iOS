//
//  Participant+CoreDataProperties.swift
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
