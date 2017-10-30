//
//  ExternalMessageModel.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 28/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

class ExternalMessageModel: NSObject {
    var messageId : String!
    var sender : ParticipantModel!
    var recipient : ParticipantModel!
    var messageTimeStamp : NSDate!
    var messageType : Int16!
    var sessionId : String!
    var senderType: Int16!
    var externalPayload : AnyObject!
    var syncedWithServer : String!
    var messageDateStamp : String!

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
            if let content = dataInfo[Constants.kContentKey]{
                self.externalPayload = content as AnyObject
            }
        }
    }

    
    
}
