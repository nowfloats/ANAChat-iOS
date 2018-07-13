//
//  PreferencesManager.swift
//

import UIKit

class PreferencesManager: NSObject {
    static let sharedInstance = PreferencesManager()
    var baseThemeColor : UIColor?
    var senderThemeColor : UIColor?
    var contentTextFont : UIFont?
    var businessId : String?
    var flowId : String?
    var additionalParams : Dictionary<String, Any>?
    var stripHtmlTags : Bool?

    func configureBaseTheme(withColor baseThemeColor : UIColor){
        self.baseThemeColor = baseThemeColor
    }
    
    func getBaseThemeColor() -> UIColor{
        if self.baseThemeColor != nil{
            return self.baseThemeColor!
        }
        return UIConfigurationUtility.Colors.BaseThemeColor
    }
    
    func configureSenderTheme(withColor senderThemeColor : UIColor){
        self.senderThemeColor = senderThemeColor
    }
    
    func getSenderThemeColor() -> UIColor{
        if self.senderThemeColor != nil{
            return self.senderThemeColor!
        }
        return UIConfigurationUtility.Colors.SenderThemeColor
    }
    
    
    func configureContentText(withFont contentTextFont : UIFont){
        self.contentTextFont = contentTextFont
    }
    
    func getContentFont() -> UIFont{
        if self.contentTextFont != nil{
            return self.contentTextFont!
        }
        return UIConfigurationUtility.Fonts.TextLblFont!
    }
    
    func configureBusinessId(withText businessId : String){
        self.businessId = businessId
    }
    
    func getBusinessId() -> String{
        if self.businessId != nil{
            return self.businessId!
        }
        return Constants.kStaticBusinessId
    }
    
    func configureFlowId(withText flowId : String){
        self.flowId = flowId
    }
    
    func getFlowId() -> String{
        if self.flowId != nil{
            return self.flowId!
        }
        return Constants.kStaticFlowId
    }
    
    func configureAdditionalParameters(withDict params: Dictionary<String, Any>?){
        self.additionalParams = params
    }
    
    func getAdditionalParamsInfo() -> NSString{
        if let params = self.additionalParams{
            if params.count > 0{
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                    return NSString.init(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return ""
    }
    
    func appendAdditionalParamsInfo(_ params : [String : Any]) -> NSString {
        if params.count > 0{
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                return NSString.init(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
            } catch {
                print(error.localizedDescription)
            }
        }
        return ""
    }
    
    class func setUserId(_ userId: String){
        // Create UserDefaults
        let defaults = UserDefaults.standard
        
        // Save String value to UserDefaults
        // Using defaults.set(value: Any?, forKey: String)
        defaults.set(userId, forKey: DataBaseConstans.kUserIdKey)
        defaults.synchronize()
    }
    
    class func getUserId() -> String{
        let defaults = UserDefaults.standard
        if let userIdString = defaults.string(forKey: DataBaseConstans.kUserIdKey) {
            return userIdString
        }
        return ""
    }
    
    func configureStripHtmlTags(withStrip stripTags : Bool) {
        self.stripHtmlTags = stripTags
    }
    
    func getStripHtmlTags() -> Bool {
        if let stripTags = self.stripHtmlTags {
            return stripTags
        }
        return false
    }
}
