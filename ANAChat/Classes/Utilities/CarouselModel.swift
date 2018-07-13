//
//  CarouselModel.swift
//

import UIKit

class CarouselModel: NSObject {
    
    var messageId : String!
    var sender : ParticipantModel!
    var recipient : ParticipantModel!
    var messageTimeStamp : NSDate!
    var messageType : Int16!
    var senderType: Int16!
    var sessionId : String!
    var Items : NSArray!
    var syncedWithServer : String!
    var messageDateStamp : String!
    var inputInfo : AnyObject!
    var mandatory: Int16!
    var prevFlowId : String!
    var currentFlowId : String!
    var flowId : String!
    
    override init ()
    {
        super.init()
    }
    
    convenience init(_ dictionary: Dictionary<String, Any>) {
        
        self.init()
        if let metaInfo = dictionary[Constants.kMetaKey] as? NSDictionary{
            if let senderInfo = metaInfo[Constants.kSenderKey] as? NSDictionary{
                self.sender = ParticipantModel.init(senderInfo as! Dictionary<String, Any>)
            }
            if let recipientInfo = metaInfo[Constants.kRecipientKey] as? NSDictionary{
                self.recipient = ParticipantModel.init(recipientInfo as! Dictionary<String, Any>)
            }
            if let messageId = metaInfo[Constants.kIdKey] as? String{
                self.messageId = messageId
            }
            if let flowId = metaInfo[Constants.kFlowIdKey] as? String{
                self.flowId = flowId
            }
            
            if let previousFlowId = metaInfo[Constants.kPreviousFlowId] as? String{
                self.prevFlowId = previousFlowId
            }
            
            if let currentFlowId = metaInfo[Constants.kCurrentFlowId] as? String{
                self.currentFlowId = currentFlowId
            }
            if let messageTimeStamp = metaInfo[Constants.kTimeStampKey] as? Double{
                let timeStampString = NSString(format : "%f",messageTimeStamp)
                self.messageTimeStamp = CommonUtility.getDate(fromString: timeStampString)
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let strDate = dateFormatter.string(from: self.messageTimeStamp as Date)
                let newDateFormatter = DateFormatter()
                newDateFormatter.dateFormat = "yyyy-MM-dd"
                self.messageDateStamp = strDate
            }

            if let senderType = metaInfo[Constants.kSenderTypeKey] as? NSInteger{
                if senderType == 0 {
                    self.senderType = Int16(MessageSenderType.MessageSenderTypeUser.rawValue)
                }else{
                    self.senderType = Int16(MessageSenderType.MessageSenderTypeServer.rawValue)
                }
            }
            if let sessionId = metaInfo[Constants.kSessionIdKey] as? String{
                self.sessionId = sessionId
            }
        }
        
        if let dataInfo = dictionary[Constants.kDataKey] as? NSDictionary{
            
            self.syncedWithServer = "1"
            
            if let messageType = dataInfo[Constants.kTypeKey] as? NSInteger{
                self.messageType = Int16(messageType)
            }
            
            if let contentInfo = dataInfo[Constants.kContentKey] as? NSDictionary{
                let carouselItemsArray = NSMutableArray()
                if let itemsArray = contentInfo[Constants.kItemsKey] as? NSArray{
                    for (index, element) in itemsArray.enumerated() {
                        let carouselItem = CarouselItemModel.init(element as! Dictionary<String, Any>, index: index)
                        carouselItemsArray.add(carouselItem)
                    }
                    self.Items = carouselItemsArray
                }
                if let inputInfo = contentInfo[Constants.kInputKey] as? NSDictionary{
                    self.inputInfo = inputInfo
                }
                if let mandatory = contentInfo[Constants.kMandatoryKey] as? NSInteger{
                    self.mandatory = Int16(mandatory)
                }
            }
        }
    }
}
//Json Format
/*
{
    "meta": {
        "id": "0fa9fd37-1844-4a02-8bde-4de8012c51e5",
        "sender": "sender",
        "recipient": "recipient",
        "senderType": 1,
        "timestamp": 1503466840819,
        "sessionId": "cb172415-a156-4732-8d4b-4e7de20e23e0",
        "responseTo": "598faf43-9613-4bb2-8d45-79c36aac0812"
    },
    "data": {
        "type": 1,
        "content": {
            "items": [
            {
            "title": "Image",
            "desc": "This is item with image",
            "media": {
            "url": "https://upload.wikimedia.org/wikipedia/commons/9/99/Earth_rise_from_the_Moon_AS11-44-6550_2.JPG",
            "type": 0
            },
            "options": [
            {
            "title": "View",
            "value": "view"
            },
            {
            "title": "Download",
            "value": "download"
            }
            ],
            "url": "https://commons.wikimedia.org/wiki/File%3AEarth_rise_from_the_Moon_AS11-44-6550_2.JPG"
            },
            {
            "title": "Video",
            "desc": "This is item with video",
            "media": {
            "url": "https://upload.wikimedia.org/wikipedia/commons/7/7d/Cassini_Reveals_New_Ring_Quirks%2C_Shadows_During_Saturn_Equinox.ogv",
            "type": 2
            },
            "options": [
            {
            "title": "Play",
            "value": "view"
            },
            {
            "title": "Download",
            "value": "download"
            }
            ],
            "url": "https://commons.wikimedia.org/wiki/File%3ACassini_Reveals_New_Ring_Quirks%2C_Shadows_During_Saturn_Equinox.ogv"
            },
            {
            "title": "Audio",
            "desc": "This is item with audio",
            "media": {
            "url": "https://upload.wikimedia.org/wikipedia/commons/a/ab/Rain_and_thunder_%2801%29.ogg",
            "type": 1
            },
            "options": [
            {
            "title": "Play",
            "value": "view"
            }
            ],
            "url": "https://commons.wikimedia.org/wiki/File%3ARain_and_thunder_(01).ogg"
            }
            ]
        }
    }
}
*/
