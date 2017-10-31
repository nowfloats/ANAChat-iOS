//
//  AppLauncherManager.swift
//

import UIKit

@objc public class AppLauncherManager: NSObject {
    
    public class func didReceiveFcmToken(withToken fcmToken: String , baseAPIUrl : String, businessId : String) {
        if baseAPIUrl.characters.count > 0{
            APIManager.sharedInstance.configureAPIBaseUrl(withString: baseAPIUrl)
            print("Firebase registration token: \(fcmToken)")
            var inputDict = [String: Any]()
            inputDict["deviceId"] = UIDevice.current.identifierForVendor!.uuidString
            inputDict["fcmNotificationId"] = fcmToken
            inputDict["devicePlatform"] = "IOS"
            
            if businessId.characters.count > 0{
                inputDict["businessId"] = businessId
            }

            APIManager.sharedInstance.post(params: inputDict, apiPath: "fcm/devices/", completionHandler: { (response) in
                print(response)
                if let userId = response["userId"] as? String{
                    PreferencesManager.setUserId(userId)
                }
            })
        }
    }
    
    public class func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any]){
        switch UIApplication.shared.applicationState {
        case .active:
            FCMMessagesManager.messageReceivedFromFCMNotification(withNotificationInfo: userInfo as NSDictionary, playSound: true)
        case .inactive,.background:
            FCMMessagesManager.messageReceivedFromFCMNotification(withNotificationInfo: userInfo as NSDictionary, playSound: false)
        }
    }
}
