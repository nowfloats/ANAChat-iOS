//
//  DataHelper.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 07/09/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit

@objc class DataHelper: NSObject {
    
    public func syncHistoryFromServer(successBlock successCompletion: @escaping (_ response: NSDictionary) -> Void){
        let responseDict = CommonUtility.loadJson(forFilename: "allChatsMock")
        FCMMessagesManager.syncHistory(withResponseObject: responseDict!) { (success) in
            successCompletion(responseDict!)
        }
    }
    
    public func updateInputDBMessage(params : [String: Any], successBlock successCompletion: @escaping (_ message: Message) -> Void){
        DispatchQueue.global(qos: .background).async {
            let inputMessageModel = InputModel.init(params)
            inputMessageModel.syncedWithServer = "0"
            CoreDataContentManager.createOrUpdateInput(withMessageInfo: inputMessageModel, successBlock: { (messageObject) in
                successCompletion(messageObject)
            }, failBlock: { (error) in
            })
        }
    }
    
    public func updateCarouselDBMessage(params : [String: Any], successBlock successCompletion: @escaping (_ message: Message) -> Void){
        DispatchQueue.global(qos: .background).async {
            let carouselMessageModel = CarouselModel.init(params)
            carouselMessageModel.syncedWithServer = "0"
            CoreDataContentManager.createOrUpdateCarousel(withMessageInfo: carouselMessageModel, successBlock: { (messageObject) in
                successCompletion(messageObject)
            }, failBlock: { (error) in
            })
        }
    }
    
    public func sendMessageToServer(params : [String: Any], apiPath : String? , messageObject : Message,completionHandler:@escaping ([String: Any]) -> ()){
        APIManager.sharedInstance.postMessageToServer(params: params, apiPath: "api",messageObject : messageObject) { (response) in
            CoreDataContentManager.updateDataBaseWithResponseObject(response, message: messageObject, successCompletion: { (success) in
                completionHandler(response)
            })
            print(response)
        }
    }
    
    public func getUnsentMessagesFromDB() -> [Any]{
        return CoreDataContentManager.getUnsentMessages()
    }
}
