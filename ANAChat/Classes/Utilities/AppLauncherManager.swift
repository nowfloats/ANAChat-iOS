//
//  AppLauncherManager.swift
//

import UIKit

@objc public class AppLauncherManager: NSObject {
    
    @objc public class func didReceiveFcmToken(withToken fcmToken: String , baseAPIUrl : String, businessId : String) {
        if baseAPIUrl.count > 0{
            APIManager.sharedInstance.configureAPIBaseUrl(withString: baseAPIUrl)
            print("Firebase registration token: \(fcmToken)")
            var inputDict = [String: Any]()
            inputDict["deviceId"] = UIDevice.current.identifierForVendor!.uuidString
            inputDict["fcmNotificationId"] = fcmToken
            inputDict["devicePlatform"] = "IOS"
            
            if businessId.count > 0{
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
    
    @objc public class func registerWithInfo(_ userId : String , fcmToken: String , baseAPIUrl : String, businessId : String){
        if baseAPIUrl.count > 0{
            APIManager.sharedInstance.configureAPIBaseUrl(withString: baseAPIUrl)
            print("Firebase registration token: \(fcmToken)")
            var inputDict = [String: Any]()
            inputDict["deviceId"] = "wkjwwjjwwfgwgh2wwwwssw22222"
            inputDict["fcmNotificationId"] = fcmToken
            inputDict["devicePlatform"] = "IOS"
            inputDict["userId"] = userId
            if businessId.count > 0{
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

    @objc public class func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any]){
        switch UIApplication.shared.applicationState {
        case .active:
            FCMMessagesManager.messageReceivedFromFCMNotification(withNotificationInfo: userInfo as NSDictionary, playSound: true)
        case .inactive,.background:
            FCMMessagesManager.messageReceivedFromFCMNotification(withNotificationInfo: userInfo as NSDictionary, playSound: false)
        }
    }
}
