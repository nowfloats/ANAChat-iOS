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

    public class func getFrameworkBundle() -> Bundle{
        let podBundle = Bundle(for: CoreDataManager.self)
        if  let bundleURL = podBundle.url(forResource: "ANAChat", withExtension: "bundle"){
            let bundle = Bundle(url : bundleURL)
            return bundle!
        }else{
            return Bundle.main
        }
    }
    
    public class func getImageFromBundle(name: String) -> UIImage {
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
        return date;
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
}
