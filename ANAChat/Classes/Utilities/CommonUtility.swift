//
//  CommonUtility.swift
//

import UIKit

@objc public class CommonUtility: NSObject {
    
    public class func timeBasedUUID() -> String {
        let uuidSize = MemoryLayout<uuid_t>.size
        let uuidPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: uuidSize)
        uuid_generate_time(uuidPointer)
        let uuid = NSUUID(uuidBytes: uuidPointer)
        uuidPointer.deallocate(capacity: uuidSize)
        return uuid.uuidString.lowercased()
    }

    @objc public class func getFrameworkBundle() -> Bundle{
        let podBundle = Bundle(for: CoreDataManager.self)
        if  let bundleURL = podBundle.url(forResource: "ANAChat", withExtension: "bundle"){
            let bundle = Bundle(url : bundleURL)
            return bundle!
        }else{
            return Bundle.main
        }
    }
    
    @objc public class func getImageFromBundle(name: String) -> UIImage {
        return UIImage(named: name, in: CommonUtility.getFrameworkBundle(), compatibleWith: nil)!
    }
    
   public class func loadJson(forFilename fileName: String) -> NSDictionary? {
        if let url = getFrameworkBundle().url(forResource: fileName, withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
                    return dictionary
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        }
        return nil
    }
    
    public class func getDate(fromString dateString : NSString) -> NSDate{
        let date = NSDate(timeIntervalSince1970:TimeInterval(dateString.doubleValue/1000))
        return date
    }
    
    public class func getTimeInterval(fromDate date : NSDate) -> Int{
        return Int(date.timeIntervalSince1970*1000)
    }

    public class func getTimeString(_ messageTimestamp : NSDate) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let timeStamp = dateFormatter.string(from: messageTimestamp as Date)
        return timeStamp
    }
    
    
    public class func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    public class func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad:     "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    public class func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
        }
        return payload
    }
    
    public class func heightOfCell(with text: String) -> CGFloat{
        #if swift(>=4.0)
            let rect: CGRect = text.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 155, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: PreferencesManager.sharedInstance.getContentFont() ], context: nil)
            return rect.size.height + 63
        #else
            let rect: CGRect = text.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 155, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: PreferencesManager.sharedInstance.getContentFont() ], context: nil)
            return rect.size.height + 63
        #endif
    }
    
    public class func compareTwoMessageObjects(_ firstMessageObject: Message , secondMessageObject : Message?) -> Bool{
        var sameParticipant = false
        if secondMessageObject == nil{
            return false
        }
        
        if firstMessageObject.senderType == secondMessageObject?.senderType {
            sameParticipant = true
            if secondMessageObject?.senderType == Int16(MessageSenderType.MessageSenderTypeServer.rawValue) , secondMessageObject?.messageType == Int16(MessageType.MessageTypeInput.rawValue){
                sameParticipant = false
            }
            if secondMessageObject?.senderType == Int16(MessageSenderType.MessageSenderTypeUser.rawValue) , secondMessageObject?.messageType == Int16(MessageType.MessageTypeLoadingIndicator.rawValue){
                sameParticipant = false
            }
        }else{
            sameParticipant = false
        }
        return sameParticipant
    }
    
    public class func getDateTextFromMessageObject(_ inputDate : InputDate) -> String{
        var dateString  = String()
        if let inputInfo = inputDate.inputInfo as? NSDictionary{
            if let dateInfo = inputInfo[Constants.kDateKey] as? NSDictionary{
                if let dayInfo = dateInfo[Constants.kMdayKey] as? NSNumber, let monthInfo = dateInfo[Constants.kMonthKey] as? NSNumber, let yearInfo = dateInfo[Constants.kYearKey] as? NSNumber {
                    dateString = String(format :  "%02d-%02d-%02d",dayInfo.intValue,monthInfo.intValue,yearInfo.intValue)
                }
            }
        }
        return dateString
    }
    
    public class func getTimeTextFromMessageObject(_ inputTime : InputTime) -> String{
        var timeString  = String()
        if let inputInfo = inputTime.inputInfo as? NSDictionary{
            if let dateInfo = inputInfo[Constants.kTimeKey] as? NSDictionary{
                if let hourInfo = dateInfo[Constants.kHourKey] as? NSNumber, let minuteInfo = dateInfo[Constants.kMinuteKey] as? NSNumber, let _ = dateInfo[Constants.kSecondKey] as? NSNumber {
                    var hourInInt = hourInfo.intValue
                    let minuteInInt = minuteInfo.intValue
                    if hourInInt > 12{
                        hourInInt =  hourInfo.intValue - 12
                        timeString = String(format :  "%02d:%02d PM",hourInInt,minuteInInt)
                    }else{
                        timeString = String(format :  "%02d:%02d AM",hourInInt,minuteInInt)
                    }
                }
            }
        }
        return timeString
    }
    
    public class func getAddressTextFromMessageObject(_ inputAddress : InputAddress) -> String{
        var addressString  = String()
        if let inputInfo = inputAddress.inputInfo as? NSDictionary{
            if let addressInfo = inputInfo[Constants.kAddressKey] as? NSDictionary{
                if let lineInfo = addressInfo[Constants.kLineAddressKey] as? String{
                    addressString.append(lineInfo)
                    addressString.append(",")
                }
                if let areaInfo = addressInfo[Constants.kAreaKey] as? String{
                    addressString.append(areaInfo)
                    addressString.append(",")
                }
                if let cityInfo = addressInfo[Constants.kCityKey] as? String{
                    addressString.append(cityInfo)
                    addressString.append(",")
                }
                if let stateInfo = addressInfo[Constants.kStateKey] as? String{
                    addressString.append(stateInfo)
                    addressString.append(",")
                }
                if let countryInfo = addressInfo[Constants.kCountryInfo] as? String{
                    addressString.append(countryInfo)
                    addressString.append(",")
                }
                if let pinInfo = addressInfo[Constants.kPinInfo] as? String{
                    addressString.append(pinInfo)
                }
            }
        }
        return addressString
    }
    
    @objc public class func getEventsDictionaryForAdditionalParams() -> Array<Any>{
        var eventsArray = Array<Any>()
        eventsArray.append(["type" : NSNumber(value: 21) , "data" : PreferencesManager.sharedInstance.getAdditionalParamsInfo()])
        return eventsArray
    }

}
