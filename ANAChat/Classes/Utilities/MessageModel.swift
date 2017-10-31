//
//  MessageModel.swift
//

import UIKit

class MessageModel: NSObject {
    
    var messageId : String!
    var sender : ParticipantModel!
    var recipient : ParticipantModel!
    var messageTimeStamp : NSDate!
    var messageType : Int16!
    var sessionId : String!
    var senderType: Int16!
    var messageText : String!
    var mediaUrl   : String!
    var mediaType : Int16!
    var previewUrl : String!
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

                print(strDate)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                let dateString = dateFormatter.string(from: self.messageTimeStamp as Date)
//                let newDateFormatter = DateFormatter()
//                newDateFormatter.dateFormat = "yyyy-MM-dd"
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
            if let messageType = dataInfo[Constants.kTypeKey] as? NSInteger{
                self.messageType = Int16(messageType)
            }
            self.syncedWithServer = "1"
 
            if let contentInfo = dataInfo[Constants.kContentKey] as? NSDictionary{
                if let text = contentInfo[Constants.kTextKey] as? String{
                    self.messageText = text
                }
                if let mediaInfo = contentInfo[Constants.kMediaKey] as? NSDictionary{
                    if let mediaType = mediaInfo[Constants.kTypeKey] as? NSInteger{
                        switch mediaType {
                        case 0:
                            self.mediaType = Int16(MessageSimpleType.MessageSimpleTypeImage.rawValue)
                        case 1:
                            self.mediaType = Int16(MessageSimpleType.MessageSimpleTypeAudio.rawValue)
                        case 2:
                            self.mediaType = Int16(MessageSimpleType.MessageSimpleTypeVideo.rawValue)
                        case 3:
                            self.mediaType = Int16(MessageSimpleType.MessageSimpleTypeFILE.rawValue)
                        default:
                            self.mediaType = Int16(MessageSimpleType.MessageSimpleTypeText.rawValue)
                        }
                    }
                    if let mediaUrl = mediaInfo[Constants.kUrlKey] as? String{
                        self.mediaUrl  = mediaUrl
                    }
                    if let previewUrl = mediaInfo[Constants.kPreviewUrlKey] as? String{
                        self.previewUrl = previewUrl
                    }
                }else{
                    self.mediaType = Int16(MessageSimpleType.MessageSimpleTypeText.rawValue)
                }
            }
        }
    }
}

//Json Format
/*
{
    "meta": {
        "id": "b07b7707-d9b4-4824-bb06-41682de6d03a",
        "sender": "sender",
        "recipient": "recipient",
        "senderType": 1,
        "timestamp": 1503466800441,
        "sessionId": "b26b3494-ce3f-4919-9b46-408fbc45c437",
        "responseTo": "b5a762c6-a280-4680-ae29-eda544c621d2"
    },
    "data": {
        "type": 1,
        "content": {
            "text": "This message has media",
            "media": {
                "url": "https://upload.wikimedia.org/wikipedia/commons/6/6f/Earth_Eastern_Hemisphere.jpg",
                "type": 0,
                "previewUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Earth_Eastern_Hemisphere.jpg/240px-Earth_Eastern_Hemisphere.jpg"
            }
        }
    }
}
 */
