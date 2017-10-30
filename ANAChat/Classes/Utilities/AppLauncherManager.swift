//
//  AppLauncherManager.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 23/10/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

class AppLauncherManager: NSObject {
    
    public class func didReceiveFcmToken(_ fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        var inputDict = [String: Any]()
        inputDict["deviceId"] = UIDevice.current.identifierForVendor!.uuidString
        inputDict["fcmNotificationId"] = fcmToken
        inputDict["devicePlatform"] = "IOS"
        
        APIManager.sharedInstance.post(params: inputDict, apiPath: "fcm/devices/", completionHandler: { (response) in
            print(response)
            if let userId = response["userId"] as? String{
                PreferencesManager.setUserId(userId)
            }
        })
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
