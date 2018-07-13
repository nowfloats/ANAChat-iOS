//
//  RequestHelper.swift
//

import UIKit

class RequestHelper: NSObject {
    
    public class func getRequestDictionary(_ messageObject: Message, inputDict:[String: Any]?) -> [String: Any] {
        var requestDictionary = [String: Any]()
        var metaInfo = [String: Any]()
   
        var senderInfo = [String: Any]()
        senderInfo[Constants.kIdKey] = PreferencesManager.getUserId()
        senderInfo[Constants.kMediumKey] = NSNumber(value:0)
        metaInfo[Constants.kSenderKey] = senderInfo
        
//        metaInfo[Constants.kIdKey] = CommonUtility.timeBasedUUID()
        if let messageTimeStamp = messageObject.timestamp as Date?{
            metaInfo[Constants.kTimeStampKey] = NSNumber(value : messageTimeStamp.millisecondsSince1970)
        }else{
            metaInfo[Constants.kTimeStampKey] = NSNumber(value : Date().millisecondsSince1970)
        }

        if let _ =  messageObject.sender {
            var recipientInfo = [String: Any]()
            recipientInfo[Constants.kIdKey] = PreferencesManager.sharedInstance.getBusinessId()
            metaInfo[Constants.kRecipientKey] = recipientInfo
        }
        
        metaInfo[Constants.kSenderTypeKey] = NSNumber(value:0)

        if let sessionId = messageObject.sessionId{
            metaInfo[Constants.kSessionIdKey] = sessionId
        }
        metaInfo[Constants.kFlowIdKey] = PreferencesManager.sharedInstance.getFlowId()

        if let currentFlowId = messageObject.currentFlowId {
            metaInfo[Constants.kCurrentFlowId] = currentFlowId
        }
        if let previousFlowId = messageObject.prevFlowId {
            metaInfo[Constants.kPreviousFlowId] = previousFlowId
        }
        requestDictionary[Constants.kMetaKey] = metaInfo
        
        var dataInfo = [String: Any]()

        if messageObject.messageType == 2{
            dataInfo[Constants.kTypeKey] = NSNumber(value:messageObject.messageType)
            var contentInfo = [String: Any]()
            
            if let inputObject = messageObject as? Input{
                switch inputObject.inputType{
                case Int16(MessageInputType.MessageInputTypeText.rawValue):
                    if let inputTypeTextObject = inputObject as? InputTypeText{
                        var inputInfo = [String: Any]()
                        
                        inputInfo[Constants.kMultiLineKey] = inputTypeTextObject.multiLine
                        inputInfo[Constants.kMinLengthKey] = inputTypeTextObject.minLength
                        inputInfo[Constants.kMaxLengthKey] = inputTypeTextObject.maxLength
                        
                        if let defaultText =  inputTypeTextObject.defaultText {
                            inputInfo[Constants.kDefaultTextKey] = defaultText
                        }
                        
                        if let placeHolderText =  inputTypeTextObject.placeHolder {
                            inputInfo[Constants.kPlaceHolderKey] = placeHolderText
                        }
                        
                        contentInfo[Constants.kTextInputAttrKey] = inputInfo
                        contentInfo[Constants.kInputTypeKey] = NSNumber(value:inputObject.inputType)
                        contentInfo[Constants.kMandatoryKey] = NSNumber(value:inputObject.mandatory)
                        
                        
                        if let inputInfo = inputDict{
                            contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                        }else{
                            if let inputMessageInfo = inputObject.inputInfo as? NSDictionary{
                                contentInfo[Constants.kInputKey] = inputMessageInfo
                            }
                        }
                        
                        print(inputTypeTextObject)
                    }
                case Int16(MessageInputType.MessageInputTypeEmail.rawValue),Int16(MessageInputType.MessageInputTypePhone.rawValue),Int16(MessageInputType.MessageInputTypeNumeric.rawValue):
                    contentInfo[Constants.kInputTypeKey] = NSNumber(value:inputObject.inputType)
                    contentInfo[Constants.kMandatoryKey] = NSNumber(value:inputObject.mandatory)
                    if let inputInfo = inputDict{
                        contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                    }
                case Int16(MessageInputType.MessageInputTypeOptions.rawValue):
                    if let inputTypeOptions = inputObject as? InputTypeOptions{
                        contentInfo[Constants.kInputTypeKey] = NSNumber(value:inputObject.inputType)
                        contentInfo[Constants.kMandatoryKey] = NSNumber(value:inputObject.mandatory)
                        
                        
                        if let inputInfo = inputDict{
                            contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                        }else{
                            if let inputMessageInfo = inputObject.inputInfo as? NSDictionary{
                                contentInfo[Constants.kInputKey] = inputMessageInfo
                            }
                        }
                        let optionsMutableArray = NSMutableArray()

                        for options in inputTypeOptions.options as! Set<Options>{
                            var optionsInfo = [String: Any]()
                            optionsInfo[Constants.kTitleKey] = options.title
                            optionsInfo[Constants.kValueKey] = options.value
                            optionsInfo[Constants.kTypeKey] = options.type
                            optionsMutableArray.add(optionsInfo)
                        }
                        contentInfo[Constants.kOptionsKey] = optionsMutableArray
                        
                        if let inputInfo = inputDict{
                            contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                            if let additionalParams = inputInfo["additionalParams"] as? [String : Any] {
                                var eventsArray = Array<Any>()
                                eventsArray.append(["type" : NSNumber(value: 21) , "data" : PreferencesManager.sharedInstance.appendAdditionalParamsInfo(additionalParams)])
                                requestDictionary["events"] = eventsArray
                            }
                        }else{
                            if let inputMessageInfo = inputObject.inputInfo as? NSDictionary{
                                contentInfo[Constants.kInputKey] = inputMessageInfo
                            }
                        }
                    }                   
                case Int16(MessageInputType.MessageInputTypeList.rawValue):
                    if let inputTypeOptions = inputObject as? InputTypeOptions{
                        contentInfo[Constants.kInputTypeKey] = NSNumber(value:inputObject.inputType)
                        contentInfo[Constants.kMandatoryKey] = NSNumber(value:inputObject.mandatory)
                        
                        
                        if let inputInfo = inputDict{
                            contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                        }else{
                            if let inputMessageInfo = inputObject.inputInfo as? NSDictionary{
                                contentInfo[Constants.kInputKey] = inputMessageInfo
                            }
                        }
                        let optionsMutableArray = NSMutableArray()
                        
                        for options in inputTypeOptions.options as! Set<Options>{
                            var optionsInfo = [String: Any]()
                            optionsInfo[Constants.kTextKey] = options.title
                            optionsInfo[Constants.kValueKey] = options.value
                            optionsMutableArray.add(optionsInfo)
                        }
                        contentInfo[Constants.kValuesKey] = optionsMutableArray
                        
                        if let inputInfo = inputDict{
                            contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                        }else{
                            if let inputMessageInfo = inputObject.inputInfo as? NSDictionary{
                                contentInfo[Constants.kInputKey] = inputMessageInfo
                            }
                        }
                    }
                case Int16(MessageInputType.MessageInputTypeMedia.rawValue):
                    if let inputTypeOptions = inputObject as? InputTypeMedia{
                        contentInfo[Constants.kInputTypeKey] = NSNumber(value:inputObject.inputType)
                        contentInfo[Constants.kMandatoryKey] = NSNumber(value:inputObject.mandatory)
                        
                        
                        if let inputInfo = inputDict{
                            contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                        }else{
                            if let inputMessageInfo = inputObject.inputInfo as? NSDictionary{
                                contentInfo[Constants.kInputKey] = inputMessageInfo
                            }
                        }
                        contentInfo[Constants.kMediaTypeKey] = NSNumber(value:inputTypeOptions.mediaType)
                    }
                case Int16(MessageInputType.MessageInputTypeDate.rawValue):
                    if let inputTypeDate = inputObject as? InputDate{
                        contentInfo[Constants.kInputTypeKey] = NSNumber(value:inputObject.inputType)
                        contentInfo[Constants.kMandatoryKey] = NSNumber(value:inputObject.mandatory)
                        
                        if let inputInfo = inputDict{
                            contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                        }else{
                            if let inputMessageInfo = inputObject.inputInfo as? NSDictionary{
                                contentInfo[Constants.kInputKey] = inputMessageInfo
                            }
                        }
                        if let dateRange = inputTypeDate.dateRange{
                            var dateRangeInfo = [String: Any]()
                            var minInfo = [String: Any]()
                            var maxInfo = [String: Any]()

                            if let minYear = dateRange.minYear{
                                minInfo[Constants.kYearKey] = minYear
                            }
                            if let minMonth = dateRange.minMonth{
                                minInfo[Constants.kMonthKey] = minMonth
                            }
                            if let minDay = dateRange.minDay{
                                minInfo[Constants.kMdayKey] = minDay
                            }
                            if let maxYear = dateRange.maxYear{
                                maxInfo[Constants.kYearKey] = maxYear
                            }
                            if let maxMonth = dateRange.maxMonth{
                                maxInfo[Constants.kMonthKey] = maxMonth
                            }
                            if let maxDay = dateRange.maxDay{
                                maxInfo[Constants.kMdayKey] = maxDay
                            }
                            
                            if let interval = dateRange.interval{
                                dateRangeInfo[Constants.kIntervalKey] = interval
                            }
                            
                            dateRangeInfo[Constants.kMinimumKey] = minInfo
                            dateRangeInfo[Constants.kMaximumKey] = maxInfo
                            
                            contentInfo[Constants.kDateRangeKey] = dateRangeInfo

                        }

                    }
                case Int16(MessageInputType.MessageInputTypeTime.rawValue):
                    if let inputTypeDate = inputObject as? InputTime{
                        contentInfo[Constants.kInputTypeKey] = NSNumber(value:inputObject.inputType)
                        contentInfo[Constants.kMandatoryKey] = NSNumber(value:inputObject.mandatory)
                        
                        if let inputInfo = inputDict{
                            contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                        }else{
                            if let inputMessageInfo = inputObject.inputInfo as? NSDictionary{
                                contentInfo[Constants.kInputKey] = inputMessageInfo
                            }
                        }
                        if let timeRange = inputTypeDate.timeRange{
                            var TimeRangeInfo = [String: Any]()
                            var minInfo = [String: Any]()
                            var maxInfo = [String: Any]()
                            
                            if let minHour = timeRange.minHour{
                                minInfo[Constants.kHourKey] = minHour
                            }
                            if let minMinute = timeRange.minMinute{
                                minInfo[Constants.kMinuteKey] = minMinute
                            }
                            if let minSecond = timeRange.minSecond{
                                minInfo[Constants.kSecondKey] = minSecond
                            }
                            if let maxHour = timeRange.maxHour{
                                maxInfo[Constants.kHourKey] = maxHour
                            }
                            if let maxMinute = timeRange.maxMinute{
                                maxInfo[Constants.kMinuteKey] = maxMinute
                            }
                            if let maxSecond = timeRange.maxSecond{
                                maxInfo[Constants.kSecondKey] = maxSecond
                            }
                           
                            if let interval = timeRange.interval{
                                TimeRangeInfo[Constants.kIntervalKey] = interval
                            }
                            
                            TimeRangeInfo[Constants.kMinimumKey] = minInfo
                            TimeRangeInfo[Constants.kMaximumKey] = maxInfo
                            
                            contentInfo[Constants.kTimeRangeKey] = TimeRangeInfo
                        }
                        
                    }
                case Int16(MessageInputType.MessageInputTypeGetStarted.rawValue):
                    contentInfo[Constants.kInputTypeKey] = NSNumber(value:0)
                    contentInfo[Constants.kMandatoryKey] = NSNumber(value:inputObject.mandatory)
                    
                    if let inputInfo = inputDict{
                        contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                    }else{
                        if let inputMessageInfo = inputObject.inputInfo as? NSDictionary{
                            contentInfo[Constants.kInputKey] = inputMessageInfo
                        }
                    }
                    if PreferencesManager.sharedInstance.getAdditionalParamsInfo().length > 0{
                        requestDictionary["events"] = CommonUtility.getEventsDictionaryForAdditionalParams()
                    }
                case Int16(MessageInputType.MessageInputTypeAddress.rawValue):
                    if let inputTypeAddress = inputObject as? InputAddress{
                        contentInfo[Constants.kMandatoryKey] = NSNumber(value:inputObject.mandatory)
                        contentInfo[Constants.kInputTypeKey] = NSNumber(value:inputObject.inputType)
                        if  inputTypeAddress.requiredFields != nil {
                            if let requiredFields = inputTypeAddress.requiredFields as? NSArray{
                                contentInfo[Constants.kRequiredFieldsKey] = requiredFields
                            }
                        }
                        if let inputInfo = inputDict{
                            contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                        }else{
                            if let inputMessageInfo = inputObject.inputInfo as? NSDictionary{
                                contentInfo[Constants.kInputKey] = inputMessageInfo
                            }
                        }
                    }
                case Int16(MessageInputType.MessageInputTypeLocation.rawValue):
                    if let inputTypeLocation = inputObject as? InputLocation{
                        contentInfo[Constants.kMandatoryKey] = NSNumber(value:inputObject.mandatory)
                        contentInfo[Constants.kInputTypeKey] = NSNumber(value:inputObject.inputType)
                        var defaultLocation = [String: Any]()
                        if let latitude = inputTypeLocation.latitude{
                            defaultLocation[Constants.kLatitudeKey] = latitude
                        }
                        if let longitude = inputTypeLocation.longitude{
                            defaultLocation[Constants.kLongitudeKey] = longitude
                        }
                        if let inputInfo = inputDict{
                            contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                        }
                        contentInfo[Constants.kDefaultLocationKey] = defaultLocation
                    }
                default:
                    break
                }
            }
            dataInfo[Constants.kContentKey] = contentInfo
        }else if messageObject.messageType == 1{
            dataInfo[Constants.kTypeKey] = NSNumber(value:messageObject.messageType)
            var contentInfo = [String: Any]()
            
            if let _ = messageObject as? Carousel{
                if let inputInfo = inputDict{
                    contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
                    dataInfo[Constants.kContentKey] = contentInfo
                }
            }
        }
        
        requestDictionary[Constants.kDataKey] = dataInfo
        
        /*
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            print(decoded)
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                // use dictFromJSON
            }
        } catch {
            print(error.localizedDescription)
        }
        */
        print(requestDictionary)
        return requestDictionary
    }

    public class func getRequestDictionaryForEmptyMessageObject(_ messageObject: Message, inputDict:[String: Any]?) -> [String: Any] {
        var requestDictionary = [String: Any]()

        var metaInfo = [String: Any]()
        
        var senderInfo = [String: Any]()
        senderInfo[Constants.kIdKey] = PreferencesManager.getUserId()
        senderInfo[Constants.kMediumKey] = NSNumber(value:0)
        metaInfo[Constants.kSenderKey] = senderInfo
        
        //        metaInfo[Constants.kIdKey] = CommonUtility.timeBasedUUID()
        if let messageTimeStamp = messageObject.timestamp as Date?{
            metaInfo[Constants.kTimeStampKey] = NSNumber(value : messageTimeStamp.millisecondsSince1970)
        }else{
            metaInfo[Constants.kTimeStampKey] = NSNumber(value : Date().millisecondsSince1970)
        }
        
        if let receiver =  messageObject.sender {
            var recipientInfo = [String: Any]()
            if let id = receiver.id{
                recipientInfo[Constants.kIdKey] = id
            }
            recipientInfo[Constants.kMediumKey] = NSNumber(value:receiver.medium)
            
            metaInfo[Constants.kRecipientKey] = recipientInfo
        }
        
        metaInfo[Constants.kSenderTypeKey] = NSNumber(value:0)
        
        if let sessionId = messageObject.sessionId{
            metaInfo[Constants.kSessionIdKey] = sessionId
        }
        
        requestDictionary[Constants.kMetaKey] = metaInfo
        
        var dataInfo = [String: Any]()
        dataInfo[Constants.kTypeKey] = NSNumber(value:2)

        var contentInfo = [String: Any]()
        contentInfo[Constants.kInputTypeKey] = NSNumber(value:0)

        if let inputInfo = inputDict{
            contentInfo[Constants.kInputKey] = inputInfo[Constants.kInputKey]
        }
        dataInfo[Constants.kContentKey] = contentInfo
        requestDictionary[Constants.kDataKey] = dataInfo

        return requestDictionary
    }
}
