//
//  InputModel.swift
//

import UIKit

class InputModel: NSObject {
    var messageId : String!
    var sender : ParticipantModel!
    var recipient : ParticipantModel!
    var messageTimeStamp : NSDate!
    var messageType : Int16!
    var senderType: Int16!
    var sessionId : String!
    var requiredFields: NSArray!
    var inputType: Int16!
    var mandatory: Int16!
    var inputAttributes : AnyObject!
    var syncedWithServer : String!
    var inputInfo : AnyObject!
    var messageDateStamp : String!
    var multiple: Int16!
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
            }else{
                self.messageTimeStamp = NSDate()
            }
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let strDate = dateFormatter.string(from: self.messageTimeStamp as Date)
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "yyyy-MM-dd"
            self.messageDateStamp = strDate

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
                if let requiredFieldsInfo =  contentInfo[Constants.kRequiredFieldsKey] as? NSArray{
                    self.requiredFields = requiredFieldsInfo
                }
                
                if let inputType = contentInfo[Constants.kInputTypeKey] as? NSInteger{
                    self.inputType = Int16(inputType)
                    switch inputType {
                    case MessageInputType.MessageInputTypeText.rawValue:
                        if let textAttributesInfo =  contentInfo[Constants.kTextInputAttrKey] as? NSDictionary{
                            self.inputAttributes = InputTextModel.init(textAttributesInfo as! Dictionary<String, Any>)
                        }
                    case MessageInputType.MessageInputTypeEmail.rawValue: break
                    case MessageInputType.MessageInputTypeNumeric.rawValue: break
                    case MessageInputType.MessageInputTypePhone.rawValue: break
                    case MessageInputType.MessageInputTypeAddress.rawValue: break
                    case MessageInputType.MessageInputTypeList.rawValue:
                        let optionsMutableArray = NSMutableArray()
                        if let optionsArray = contentInfo[Constants.kValuesKey] as? NSArray{
                            for (index, element) in optionsArray.enumerated() {
                                let optionsModel = OptionsModel.init(element as! Dictionary<String, Any>, index: index,list : true)
                                optionsMutableArray.add(optionsModel)
                            }
                            self.inputAttributes = optionsMutableArray
                        }
                        if let multiple = contentInfo[Constants.kMultipleKey] as? NSInteger{
                            self.multiple = Int16(multiple)
                        }
                    case MessageInputType.MessageInputTypeOptions.rawValue:
                        let optionsMutableArray = NSMutableArray()
                        if let optionsArray = contentInfo[Constants.kOptionsKey] as? NSArray{
                            for (index, element) in optionsArray.enumerated() {
                                let optionsModel = OptionsModel.init(element as! Dictionary<String, Any>, index: index, list : nil)
                                optionsMutableArray.add(optionsModel)
                            }
                            self.inputAttributes = optionsMutableArray
                        }
                    case MessageInputType.MessageInputTypeTime.rawValue:
                        if let timeRangeInfo = contentInfo[Constants.kTimeRangeKey] as? NSDictionary{
                            let timeRangeModel = InputTimeModel.init(timeRangeInfo as! Dictionary<String, Any>)
                            self.inputAttributes = timeRangeModel
                        }
                    case MessageInputType.MessageInputTypeDate.rawValue:
                        if let timeRangeInfo = contentInfo[Constants.kDateRangeKey] as? NSDictionary{
                            let dateRangeModel = InputDateModel.init(timeRangeInfo as! Dictionary<String, Any>)
                            self.inputAttributes = dateRangeModel
                        }
                    case MessageInputType.MessageInputTypeLocation.rawValue:
                        if let locationInfo = contentInfo[Constants.kDefaultLocationKey] as? NSDictionary{
                            let locationModel = InputLocationModel.init(locationInfo as! Dictionary<String, Any>)
                            self.inputAttributes = locationModel
                        }
                    case MessageInputType.MessageInputTypeMedia.rawValue:
                        if let contentInfo = dataInfo[Constants.kContentKey] as? NSDictionary{
                            let mediaModel = InputMediaModel.init(contentInfo as! Dictionary<String, Any>)
                            self.inputAttributes = mediaModel
                        }
                    default:
                        print("default detected")
                    }
                }
                if let mandatory = contentInfo[Constants.kMandatoryKey] as? NSInteger{
                    self.mandatory = Int16(mandatory)
                }
                if let inputInfo = contentInfo[Constants.kInputKey] as? NSDictionary{
                    self.inputInfo = inputInfo
                }
            }
        }
    }
}
