//
//  FCMMessagesManager.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 12/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit
import AudioToolbox

public class FCMMessagesManager: NSObject {

    static var dataArray = MessagesDataSource()
    static var isSyncing = Bool()

    public class func messageReceivedFromFCMNotification(withNotificationInfo notificationInfo: NSDictionary, playSound : Bool){
         do {
         let jsonData = try JSONSerialization.data(withJSONObject: notificationInfo, options: .prettyPrinted)
         // here "jsonData" is the dictionary encoded in JSON data
         
         let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
         // here "decoded" is of type `Any`, decoded from JSON data
         print(decoded)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            print(jsonString)
            
         // you can now cast it with the right type
         if let dictFromJSON = decoded as? [String:String] {
         // use dictFromJSON
         }
         } catch {
         print(error.localizedDescription)
         }
        
        FCMMessagesManager.fcmChatMessageReceivedInsertIntoDataBase(withNotificationInfo: notificationInfo, playSound: playSound)
    }
    
    public class func fcmChatMessageReceivedInsertIntoDataBase(withNotificationInfo notificationInfo: NSDictionary, playSound : Bool){
        if let messageString = notificationInfo["payload"] as? NSString{
            let data = messageString.data(using: String.Encoding.utf8.rawValue)
            do {
                let messageDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                FCMMessagesManager.fcmChatMessageReceivedInsertIntoDataBase(withResponseMessageDictionary: messageDictionary as NSDictionary, playSound: playSound)
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    
    public class func fcmChatMessageReceivedInsertIntoDataBase(withResponseMessageDictionary messageDictionary: NSDictionary, playSound : Bool){
        self.dataArray.enqueue(messageDictionary)

        if !self.isSyncing{
            self.syncMessagesWithDelay()
        }
    }
    
    public class func syncMessagesWithDelay(){
        func notifyUserNewMessageBlock(success : Bool){
            /*
             if playSound == true, success == true{
             AudioServicesPlaySystemSound(1007);
             }
             */
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConstants.kMessageReceivedNotification), object: nil)
        }
        if (self.isSyncing){
            return
        }
        
        isSyncing = true
        CoreDataContentManager.deleteAllWaitingPlaceholderImages { (success) in
            
            if self.dataArray.list.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {

                    CoreDataContentManager.addWaitingPlaceholderCell(withCompletionBlock: { (success) in
                        notifyUserNewMessageBlock(success: true)
                    })
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dataArray.list = self.dataArray.list.ascendingArrayWithKeyValue(key: "meta.timestamp").mutableCopy() as! NSMutableArray
                    self.syncMessage(withMessageObject: (self.dataArray.peek())!) { (success, messageInfo) in
                        if self.dataArray.list.contains(messageInfo){
                            self.dataArray.list.remove(messageInfo)
                        }
                        isSyncing = false
                        if success{
                            CoreDataContentManager.deleteAllWaitingPlaceholderImages { (success) in
                                notifyUserNewMessageBlock(success: true)
                                if !self.dataArray.isEmpty{
                                    self.syncMessagesWithDelay()
                                }
                            }
                        }
                    }
                }
            }else{
                isSyncing = false
                CoreDataContentManager.deleteAllWaitingPlaceholderImages { (success) in
                }
            }
        }
    }
    /*
    public class func addToDBAfterDelay(){
        func notifyUserNewMessageBlock(success : Bool){
            /*
             if playSound == true, success == true{
             AudioServicesPlaySystemSound(1007);
             }
             */
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConstants.kMessageReceivedNotification), object: nil)
        }
        
        self.syncMessage(withMessageObject: (self.dataArray.peek())!) { (success, messageInfo) in
            print("New object Inserted")
            if self.dataArray.list.contains(messageInfo){
                self.dataArray.list.remove(messageInfo)
            }
            isSyncing = false
            if success{
                CoreDataContentManager.deleteAllWaitingPlaceholderImages { (success) in
                    notifyUserNewMessageBlock(success: true)
                    if !self.dataArray.isEmpty{
                        self.syncMessagesWithDelay()
                    }else{
                        self.timer.invalidate()
                    }
                }
            }
        }
    }
 */
    
    public class func syncHistory(withResponseObject responseInfo:NSDictionary, successBlock successCompletion: @escaping (_ success: Bool) -> Void){
        if let chatsArray = responseInfo["chats"] as? NSArray{
            if chatsArray.count == 0 {
                successCompletion(true)
            }
            for case let item as NSDictionary in chatsArray{
                FCMMessagesManager.syncMessage(withMessageObject: item, successBlock: { (success , messageInfo) in
                    if chatsArray.lastObject as! NSDictionary == item{
                        successCompletion(true)
                    }
                })
            }
        }
    }
    
    public class func syncMessage(withMessageObject messageInfo:NSDictionary, successBlock successCompletion: @escaping (_ success: Bool , _ messageInfo : NSDictionary) -> Void){
        if let dataInfo = messageInfo["data"] as? NSDictionary{
            if let messageType = dataInfo["type"] as? NSInteger{
                switch messageType {
                case 0:
                    let simpleMessageModel = MessageModel.init(messageInfo as! Dictionary<String, Any>)
                    CoreDataContentManager.createOrUpdateMessage(withMessageInfo: simpleMessageModel, successBlock: { (messageObject) in
                        successCompletion(true,messageInfo)
                    }, failBlock: { (error) in
                        successCompletion(false, messageInfo)
                    })
                case 1:
                    let carouselMessageModel = CarouselModel.init(messageInfo as! Dictionary<String, Any>)
                    CoreDataContentManager.createOrUpdateCarousel(withMessageInfo: carouselMessageModel, successBlock: { (messageObject) in
                        successCompletion(true,messageInfo)
                    }, failBlock: { (error) in
                        successCompletion(false, messageInfo)
                    })
                case 2:
                    let inputMessageModel = InputModel.init(messageInfo as! Dictionary<String, Any>)
                    CoreDataContentManager.createOrUpdateInput(withMessageInfo: inputMessageModel, successBlock: { (messageObject) in
                        successCompletion(true,messageInfo)
                    }, failBlock: { (error) in
                        successCompletion(false, messageInfo)
                    })
                case 3:
                    let externalMessageModel = ExternalMessageModel.init(messageInfo as! Dictionary<String, Any>)
                    CoreDataContentManager.createOrUpdateExternal(withMessageInfo: externalMessageModel, successBlock: { (messageObject) in
                        successCompletion(true,messageInfo)
                    }, failBlock: { (error) in
                        successCompletion(false, messageInfo)
                    })
                default:
                    break
                }
            }
        }
    }
}
