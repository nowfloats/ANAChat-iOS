//
//  DataHelper.swift
//

import UIKit

@objc class DataHelper: NSObject {
    
    public func syncHistoryFromServer(params : [String: Any], apiPath : String? ,successBlock successCompletion: @escaping (_ response: NSDictionary) -> Void){
        APIManager.sharedInstance.getHistoryFromServer(params: params, apiPath: "chatdata/messages") { (response) in
            successCompletion(response as NSDictionary)
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
