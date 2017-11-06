//
//  CoreDataContentManager.swift
//

import UIKit
import CoreData

public class CoreDataContentManager: NSObject {
    class func managedObjectContext() -> NSManagedObjectContext {
        return CoreDataManager.sharedInstance.managedObjectContext
    }
    
    class func backgroundObjectContext() -> NSManagedObjectContext {
        return CoreDataManager.sharedInstance.privateContext
    }
    
    class func saveBackgroundContextWith(successBlock successCompletion: @escaping (_ success: Bool) -> Void , failBlock failCompletion: @escaping (_ error: Error?) -> Void) {
        let mainMoc = CoreDataContentManager.managedObjectContext()
        let privateMoc = CoreDataContentManager.backgroundObjectContext()
        privateMoc.perform { () -> Void in
            do {
                try privateMoc.save()
                mainMoc.perform { () -> Void in
                    do {
                        try mainMoc.save()
                        successCompletion(true)
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    class func save(){
        let mainMoc = CoreDataContentManager.managedObjectContext()
        let privateMoc = CoreDataContentManager.backgroundObjectContext()
        privateMoc.perform { () -> Void in
            do {
                try privateMoc.save()
                mainMoc.perform { () -> Void in
                    do {
                        try mainMoc.save()
                        print("successfully saved")
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    class func discardChanges() {
        let mainMoc = CoreDataContentManager.managedObjectContext()
        mainMoc.rollback()
    }
    
    class func deleteAllRecords(entityName : String) {
        let mainMoc = CoreDataContentManager.managedObjectContext()
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do {
                try mainMoc.execute(deleteRequest)
                try mainMoc.save()
            } catch {
                print ("There was an error")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    class func deleteAllMessages(successBlock successCompletion: @escaping (_ success: Bool) -> Void) {
        let fr:NSFetchRequest<Message>=Message.fetchRequest()
        do {
            let fetchedList=try CoreDataContentManager.backgroundObjectContext().fetch(fr)
            if fetchedList.count==0 {
                print("no resutls. i need to add something")
            }else{
                for i in 0 ..< fetchedList.count {
                    CoreDataContentManager.backgroundObjectContext().delete(fetchedList[i] as NSManagedObject)
                    if i == fetchedList.count - 1{
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            successCompletion(success)
                        }, failBlock: { (error) in
                            successCompletion(false)
                        })
                    }
                }
            }
        }catch {
            print(error)
        }
    }
    
    class func fetchMessages (){
        let fr:NSFetchRequest<Message>=Message.fetchRequest()
        do {
            let results=try CoreDataContentManager.managedObjectContext().fetch(fr)
            if results.count==0 {
                print("no resutls. i need to add something")
            }else{
                print("already some results")
                //                print(results)
                print(results.count)
                //                for result in results {
                //                    print(result)
                //                }
            }
        }catch {
            print(error)
        }
    }
    
    class func fetchRequest(withEntityName entity: String , predicate : NSPredicate , sortDescriptor : NSSortDescriptor) -> [Any]{
        var request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request = NSFetchRequest(entityName: entity)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        do {
            let results = try CoreDataContentManager.backgroundObjectContext().fetch(request)
            return results
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    class func fetchRequest(withEntityName entity: String , predicate : NSPredicate , sortDescriptor : NSSortDescriptor ,successBlock successCompletion: @escaping (_ fetchedObjects: [Any]) -> Void , failBlock failCompletion: @escaping (_ error: Error?) -> Void)
    {
        let managedObjectContext = CoreDataContentManager.backgroundObjectContext()
        managedObjectContext.perform { () -> Void in
            var request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
            request = NSFetchRequest(entityName: entity)
            request.sortDescriptors = [sortDescriptor]
            request.predicate = predicate
            do {
                let results = try CoreDataContentManager.backgroundObjectContext().fetch(request)
                successCompletion(results)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    class func createOrUpdateMessage(withMessageInfo messageModel:MessageModel, successBlock successCompletion: @escaping (_ simpleObject: Message) -> Void,failBlock failCompletion: @escaping (_ error: Error?) -> Void){
        let managedObjectContext = CoreDataContentManager.backgroundObjectContext()
        managedObjectContext.perform { () -> Void in
            func createNewMessage(successBlock messageCompletion: @escaping (_ simpleObject: Message) -> Void){
                //retrieve the entity
                let entity =  NSEntityDescription.entity(forEntityName: "Simple", in: managedObjectContext)
                
                let messageObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Simple
                
                if let senderInfo = messageModel.sender{
                    let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                    
                    let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                    
                    if let id = senderInfo.id{
                        senderObject.id = id
                    }
                    
                    if let medium = senderInfo.medium{
                        senderObject.medium = medium
                    }
                    
                    senderObject.senderMessage = messageObject
                    messageObject.sender = senderObject
                }
                
                if let receiverInfo = messageModel.recipient{
                    let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                    
                    let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                    
                    if let id = receiverInfo.id{
                        recipientObject.id = id
                    }
                    
                    if let medium = receiverInfo.medium{
                        recipientObject.medium = medium
                    }
                    
                    recipientObject.recipientMessage = messageObject
                    messageObject.recipient = recipientObject
                }
               
                if let messageId = messageModel.messageId{
                    messageObject.messageId = messageId
                }
                
                if let sessionId = messageModel.sessionId{
                    messageObject.sessionId = sessionId
                }
                
                if let messageTimeStamp = messageModel.messageTimeStamp{
                    messageObject.timestamp = messageTimeStamp
                }
                if let messageDateStamp = messageModel.messageDateStamp{
                    messageObject.dateStamp = messageDateStamp
                }
                
                if let senderType = messageModel.senderType{
                    messageObject.senderType = senderType
                }
                
                
                messageObject.messageId = messageObject.messageId
                
                if let messageType = messageModel.messageType{
                    messageObject.messageType = messageType
                }
                
                if let syncedWithServer = Int(messageModel.syncedWithServer) {
                    messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                }
                
                if let mediaType = messageModel.mediaType{
                    messageObject.mediaType = mediaType
                }
                
                if let messageText = messageModel.messageText{
                    messageObject.text = messageText
                }
                
                if let mediaUrl = messageModel.mediaUrl{
                    messageObject.mediaUrl  = mediaUrl
                }
                
                if let previewUrl = messageModel.previewUrl{
                    messageObject.previewUrl  = previewUrl
                }
                
                CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                    messageCompletion(messageObject)
                }, failBlock: { (error) in
                })
            }
            
            if let messageId = messageModel.messageId{
                let messagePredicate = NSPredicate(format: "(messageId == %@)",messageId)
                let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
                
                CoreDataContentManager.fetchRequest(withEntityName: "Simple", predicate: messagePredicate, sortDescriptor: sortDescriptor, successBlock: { (fetchedObjects) in
                    if fetchedObjects.count == 0 {
                        createNewMessage(successBlock: { (messageObject) in
                            successCompletion(messageObject)
                        })
                    }else{
                        let messageObject = fetchedObjects.first as! Simple
                        if let timeStamp = messageModel.messageTimeStamp{
                            messageObject.timestamp = timeStamp
                        }
                        if let messageDateStamp = messageModel.messageDateStamp{
                            messageObject.dateStamp = messageDateStamp
                        }
                        if let syncedWithServer = Int(messageModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        if let messageType = messageModel.messageType{
                            messageObject.messageType = messageType
                        }
                        
                        if let messageText = messageModel.messageText{
                            messageObject.text = messageText
                        }
                        if let mediaUrl = messageModel.mediaUrl{
                            messageObject.mediaUrl = mediaUrl
                        }
                        
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            successCompletion(fetchedObjects.first as! Message)
                        }, failBlock: { (error) in
                        })
                    }
                }) { (error) in
                }
            }
            
        }
    }
    
    class func createOrUpdateCarousel(withMessageInfo carouselModel:CarouselModel, successBlock successCompletion: @escaping (_ simpleObject: Message) -> Void,failBlock failCompletion: @escaping (_ error: Error?) -> Void){
        let managedObjectContext = CoreDataContentManager.backgroundObjectContext()
        managedObjectContext.perform { () -> Void in
            func createNewCarousel(successBlock messageCompletion: @escaping (_ simpleObject: Message) -> Void){
                //retrieve the entity
                let entity =  NSEntityDescription.entity(forEntityName: "Carousel", in: managedObjectContext)
                
                let messageObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Carousel
                
                if let senderInfo = carouselModel.sender{
                    let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                    
                    let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                    
                    if let id = senderInfo.id{
                        senderObject.id = id
                    }
                    
                    if let medium = senderInfo.medium{
                        senderObject.medium = medium
                    }
                    
                    senderObject.senderMessage = messageObject
                    messageObject.sender = senderObject
                }
                
                if let receiverInfo = carouselModel.recipient{
                    let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                    
                    let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                    
                    if let id = receiverInfo.id{
                        recipientObject.id = id
                    }
                    
                    if let medium = receiverInfo.medium{
                        recipientObject.medium = medium
                    }
                    
                    recipientObject.recipientMessage = messageObject
                    messageObject.recipient = recipientObject
                }
                
                if let messageId = carouselModel.messageId{
                    messageObject.messageId = messageId
                }
                
                if let sessionId = carouselModel.sessionId{
                    messageObject.sessionId = sessionId
                }
                
                if let syncedWithServer = Int(carouselModel.syncedWithServer) {
                    messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                }
                
                if let messageTimeStamp = carouselModel.messageTimeStamp{
                    messageObject.timestamp = messageTimeStamp
                }
                
                if let messageDateStamp = carouselModel.messageDateStamp{
                    messageObject.dateStamp = messageDateStamp
                }
                if let senderType = carouselModel.senderType{
                    messageObject.senderType = senderType
                }
                
                if let messageType = carouselModel.messageType{
                    messageObject.messageType = messageType
                }
                
                messageObject.messageId = carouselModel.messageId
                
                if let messageTimeStamp = carouselModel.messageTimeStamp{
                    messageObject.timestamp = messageTimeStamp
                }
                if let mandatory = carouselModel.mandatory{
                    messageObject.mandatory = mandatory
                }
                
                if let inputInfo = carouselModel.inputInfo as? NSDictionary{
                    messageObject.inputInfo = inputInfo
                }
                
                
                if carouselModel.Items != nil{
                    for (_, element) in carouselModel.Items.enumerated() {
                        let carouselItemEntity =  NSEntityDescription.entity(forEntityName: "CarouselItem", in: managedObjectContext)
                        let carouselItemObject = NSManagedObject(entity: carouselItemEntity!, insertInto: managedObjectContext) as! CarouselItem
                        if let carouselItemModel = element as? CarouselItemModel{
                            if let title = carouselItemModel.title{
                                carouselItemObject.title = title
                            }
                            if let desc = carouselItemModel.desc{
                                carouselItemObject.desc = desc
                            }
                            if let url = carouselItemModel.url{
                                carouselItemObject.url = url
                            }
                            if let mediaType = carouselItemModel.mediaType{
                                carouselItemObject.mediaType = mediaType
                            }
                            if let mediaUrl = carouselItemModel.mediaUrl{
                                carouselItemObject.mediaUrl = mediaUrl
                            }
                            if let previewUrl = carouselItemModel.previewUrl{
                                carouselItemObject.previewUrl = previewUrl
                            }
                            
                            if let index = carouselItemModel.index{
                                carouselItemObject.index = index
                            }
                            if carouselItemModel.options != nil {
                                for (_, element) in carouselItemModel.options.enumerated() {
                                    let optionsItemEntity =  NSEntityDescription.entity(forEntityName: "Options", in: managedObjectContext)
                                    let optionsItemObject = NSManagedObject(entity: optionsItemEntity!, insertInto: managedObjectContext) as! Options
                                    if let optionsModel = element as? OptionsModel{
                                        if let title = optionsModel.title{
                                            optionsItemObject.title = title
                                        }
                                        if let value = optionsModel.value{
                                            optionsItemObject.value = value
                                        }
                                        if let type = optionsModel.type{
                                            optionsItemObject.type = type
                                        }
                                        
                                        if let index = optionsModel.index{
                                            optionsItemObject.index = index
                                        }
                                        optionsItemObject.carouselItem = carouselItemObject
                                        carouselItemObject.addToOptions(optionsItemObject)
                                    }
                                }
                                carouselItemObject.carousel = messageObject
                                messageObject.addToItems(carouselItemObject)
                            }
                            }
                    }
                }
                CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                    messageCompletion(messageObject)
                }, failBlock: { (error) in
                })
            }
            
            if let messageId = carouselModel.messageId{
                let messagePredicate = NSPredicate(format: "(messageId == %@)",messageId)
                let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
                
                CoreDataContentManager.fetchRequest(withEntityName: "Message", predicate: messagePredicate, sortDescriptor: sortDescriptor, successBlock: { (fetchedObjects) in
                    if fetchedObjects.count == 0 {
                        createNewCarousel(successBlock: { (messageObject) in
                            successCompletion(messageObject)
                        })
                    }else{
                        let messageObject = fetchedObjects.first as! Message
                        
                        if let syncedWithServer = Int(carouselModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        
                        if let timeStamp = carouselModel.messageTimeStamp{
                            messageObject.timestamp = timeStamp
                        }
                        
                        successCompletion(fetchedObjects.first as! Message)
                    }
                }) { (error) in
                }
            }else{
                createNewCarousel(successBlock: { (messageObject) in
                    successCompletion(messageObject)
                })
            }
        }
    }
    
    class func createOrUpdateInput(withMessageInfo inputModel:InputModel, successBlock successCompletion: @escaping (_ simpleObject: Message) -> Void,failBlock failCompletion: @escaping (_ error: Error?) -> Void){
        let managedObjectContext = CoreDataContentManager.backgroundObjectContext()
        managedObjectContext.perform { () -> Void in
            func createNewInput(successBlock messageCompletion: @escaping (_ simpleObject: Message) -> Void){
                
                if let inputType = inputModel.inputType{
                    switch inputType {
                    case Int16(MessageInputType.MessageInputTypeText.rawValue):
                        let inputTextEntity =  NSEntityDescription.entity(forEntityName: "InputTypeText", in: managedObjectContext)
                        let textInputObject = NSManagedObject(entity: inputTextEntity!, insertInto: managedObjectContext) as! InputTypeText
                        
                        if let senderInfo = inputModel.sender{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = senderInfo.id{
                                senderObject.id = id
                            }
                            
                            if let medium = senderInfo.medium{
                                senderObject.medium = medium
                            }
                            
                            senderObject.senderMessage = textInputObject
                            textInputObject.sender = senderObject
                        }
                        
                        if let receiverInfo = inputModel.recipient{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = receiverInfo.id{
                                recipientObject.id = id
                            }
                            
                            if let medium = receiverInfo.medium{
                                recipientObject.medium = medium
                            }
                            
                            recipientObject.recipientMessage = textInputObject
                            textInputObject.recipient = recipientObject
                        }
                        
                        if let messageId = inputModel.messageId{
                            textInputObject.messageId = messageId
                        }
                        
                        if let syncedWithServer = Int(inputModel.syncedWithServer) {
                            textInputObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        
                        if let sessionId = inputModel.sessionId{
                            textInputObject.sessionId = sessionId
                        }
                        
                        if let messageTimeStamp = inputModel.messageTimeStamp{
                            textInputObject.timestamp = messageTimeStamp
                        }
                        
                        if let messageDateStamp = inputModel.messageDateStamp{
                            textInputObject.dateStamp = messageDateStamp
                        }
                        
                        if let senderType = inputModel.senderType{
                            textInputObject.senderType = senderType
                        }
                        
                        if let messageType = inputModel.messageType{
                            textInputObject.messageType = messageType
                        }
                        
                        if let messageId = inputModel.messageId{
                            textInputObject.messageId = messageId
                        }
                        
                        if let mandatory = inputModel.mandatory{
                            textInputObject.mandatory = mandatory
                        }
                        
                        textInputObject.inputType = inputType
                        
                        if let inputInfo = inputModel.inputInfo as? NSDictionary{
                            textInputObject.inputInfo = inputInfo
                        }
                        
                        if let inputAttributes = inputModel.inputAttributes as? InputTextModel{
                            
                            if let multiLine = inputAttributes.multiLine{
                                textInputObject.multiLine = multiLine
                            }
                            
                            if let minLength = inputAttributes.minLength{
                                textInputObject.minLength = minLength
                            }
                            if let maxLength = inputAttributes.maxLength{
                                textInputObject.maxLength = maxLength
                            }
                            if let defaultText = inputAttributes.defaultText{
                                textInputObject.defaultText = defaultText
                            }
                            if let placeHolder = inputAttributes.placeHolder{
                                textInputObject.placeHolder = placeHolder
                            }
                        }
                        
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            messageCompletion(textInputObject)
                        }, failBlock: { (error) in
                            print("error")
                        })
                        
                    case Int16(MessageInputType.MessageInputTypeEmail.rawValue),Int16(MessageInputType.MessageInputTypeNumeric.rawValue),Int16(MessageInputType.MessageInputTypePhone.rawValue):
                        //retrieve the entity
                        let entity =  NSEntityDescription.entity(forEntityName: "Input", in: managedObjectContext)
                        
                        let messageObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Input
                        
                        if let senderInfo = inputModel.sender{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = senderInfo.id{
                                senderObject.id = id
                            }
                            
                            if let medium = senderInfo.medium{
                                senderObject.medium = medium
                            }
                            
                            senderObject.senderMessage = messageObject
                            messageObject.sender = senderObject
                        }
                        
                        if let receiverInfo = inputModel.recipient{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = receiverInfo.id{
                                recipientObject.id = id
                            }
                            
                            if let medium = receiverInfo.medium{
                                recipientObject.medium = medium
                            }
                            
                            recipientObject.recipientMessage = messageObject
                            messageObject.recipient = recipientObject
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let syncedWithServer = Int(inputModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        
                        if let sessionId = inputModel.sessionId{
                            messageObject.sessionId = sessionId
                        }
                        
                        if let messageTimeStamp = inputModel.messageTimeStamp{
                            messageObject.timestamp = messageTimeStamp
                        }
                        
                        if let messageDateStamp = inputModel.messageDateStamp{
                            messageObject.dateStamp = messageDateStamp
                        }
                        
                        if let senderType = inputModel.senderType{
                            messageObject.senderType = senderType
                        }
                        
                        if let messageType = inputModel.messageType{
                            messageObject.messageType = messageType
                        }
                        
                        messageObject.inputType = inputType
                        
                        if let inputInfo = inputModel.inputInfo as? NSDictionary{
                            messageObject.inputInfo = inputInfo
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let mandatory = inputModel.mandatory{
                            messageObject.mandatory = mandatory
                        }
                        
                        
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            messageCompletion(messageObject)
                        }, failBlock: { (error) in
                            print("error")
                        })
                        
                    case Int16(MessageInputType.MessageInputTypeList.rawValue),Int16(MessageInputType.MessageInputTypeOptions.rawValue):
                        let entity =  NSEntityDescription.entity(forEntityName: "InputTypeOptions", in: managedObjectContext)
                        
                        let messageObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! InputTypeOptions
                        
                        if let senderInfo = inputModel.sender{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = senderInfo.id{
                                senderObject.id = id
                            }
                            
                            if let medium = senderInfo.medium{
                                senderObject.medium = medium
                            }
                            
                            senderObject.senderMessage = messageObject
                            messageObject.sender = senderObject
                        }
                        
                        if let receiverInfo = inputModel.recipient{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = receiverInfo.id{
                                recipientObject.id = id
                            }
                            
                            if let medium = receiverInfo.medium{
                                recipientObject.medium = medium
                            }
                            
                            recipientObject.recipientMessage = messageObject
                            messageObject.recipient = recipientObject
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let syncedWithServer = Int(inputModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        
                        if let sessionId = inputModel.sessionId{
                            messageObject.sessionId = sessionId
                        }
                        
                        if let messageTimeStamp = inputModel.messageTimeStamp{
                            messageObject.timestamp = messageTimeStamp
                        }
                        
                        if let messageDateStamp = inputModel.messageDateStamp{
                            messageObject.dateStamp = messageDateStamp
                        }
                        
                        if let senderType = inputModel.senderType{
                            messageObject.senderType = senderType
                        }
                        
                        if let messageType = inputModel.messageType{
                            messageObject.messageType = messageType
                        }
                        
                        
                        messageObject.inputType = inputType
                        
                        if let inputInfo = inputModel.inputInfo as? NSDictionary{
                            messageObject.inputInfo = inputInfo
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let mandatory = inputModel.mandatory{
                            messageObject.mandatory = mandatory
                        }
                        
                        if let multiple = inputModel.multiple{
                            messageObject.multiple = multiple
                        }
                        if let inputAttributes = inputModel.inputAttributes as? NSArray{
                            //retrieve the entity
                            
                            messageObject.inputType = inputType
                            
                            if let inputInfo = inputModel.inputInfo as? NSDictionary{
                                messageObject.inputInfo = inputInfo
                            }
                            
                            for (_, element) in inputAttributes.enumerated() {
                                let optionsItemEntity =  NSEntityDescription.entity(forEntityName: "Options", in: managedObjectContext)
                                let optionsItemObject = NSManagedObject(entity: optionsItemEntity!, insertInto: managedObjectContext) as! Options
                                if let optionsModel = element as? OptionsModel{
                                    if let title = optionsModel.title{
                                        optionsItemObject.title = title
                                    }
                                    if let value = optionsModel.value{
                                        optionsItemObject.value = value
                                    }
                                    if let type = optionsModel.type{
                                        optionsItemObject.type = type
                                    }
                                    if let index = optionsModel.index{
                                        optionsItemObject.index = index
                                    }
                                    optionsItemObject.inputTypeOptions = messageObject
                                    messageObject.addToOptions(optionsItemObject)
                                }
                            }
                        }
                        
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            messageCompletion(messageObject)
                        }, failBlock: { (error) in
                            print("error")
                        })
                        
                    case Int16(MessageInputType.MessageInputTypeTime.rawValue):
                        let entity =  NSEntityDescription.entity(forEntityName: "InputTime", in: managedObjectContext)
                        
                        let messageObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! InputTime
                        
                        if let senderInfo = inputModel.sender{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = senderInfo.id{
                                senderObject.id = id
                            }
                            
                            if let medium = senderInfo.medium{
                                senderObject.medium = medium
                            }
                            
                            senderObject.senderMessage = messageObject
                            messageObject.sender = senderObject
                        }
                        
                        if let receiverInfo = inputModel.recipient{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = receiverInfo.id{
                                recipientObject.id = id
                            }
                            
                            if let medium = receiverInfo.medium{
                                recipientObject.medium = medium
                            }
                            
                            recipientObject.recipientMessage = messageObject
                            messageObject.recipient = recipientObject
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let syncedWithServer = Int(inputModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        
                        if let sessionId = inputModel.sessionId{
                            messageObject.sessionId = sessionId
                        }
                        
                        if let messageTimeStamp = inputModel.messageTimeStamp{
                            messageObject.timestamp = messageTimeStamp
                        }
                        
                        if let messageDateStamp = inputModel.messageDateStamp{
                            messageObject.dateStamp = messageDateStamp
                        }
                        
                        if let senderType = inputModel.senderType{
                            messageObject.senderType = senderType
                        }
                        
                        if let messageType = inputModel.messageType{
                            messageObject.messageType = messageType
                        }
                        
                        messageObject.inputType = inputType
                        
                        if let inputInfo = inputModel.inputInfo as? NSDictionary{
                            messageObject.inputInfo = inputInfo
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let mandatory = inputModel.mandatory{
                            messageObject.mandatory = mandatory
                        }
                        
                        
                        if let inputAttributes = inputModel.inputAttributes as? InputTimeModel{
                            let inputTimeRangeEntity =  NSEntityDescription.entity(forEntityName: "TimeRange", in: managedObjectContext)
                            let inputTimeRangeObject = NSManagedObject(entity: inputTimeRangeEntity!, insertInto: managedObjectContext) as! TimeRange
                            if let minHour = inputAttributes.minHour{
                                inputTimeRangeObject.minHour = minHour
                            }
                            if let minMinute = inputAttributes.minMinute{
                                inputTimeRangeObject.minMinute = minMinute
                            }
                            if let minSecond = inputAttributes.minSecond{
                                inputTimeRangeObject.minSecond = minSecond
                            }
                            if let maxHour = inputAttributes.maxHour{
                                inputTimeRangeObject.maxHour = maxHour
                            }
                            if let maxMinute = inputAttributes.maxMinute{
                                inputTimeRangeObject.maxMinute = maxMinute
                            }
                            if let maxSecond = inputAttributes.maxSecond{
                                inputTimeRangeObject.maxSecond = maxSecond
                            }
                            if let interval = inputAttributes.interval{
                                inputTimeRangeObject.interval = interval
                            }
                            inputTimeRangeObject.inputTime = messageObject
                            messageObject.timeRange = inputTimeRangeObject
                        }
                        
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            messageCompletion(messageObject)
                        }, failBlock: { (error) in
                            print("error")
                        })
                        
                    case Int16(MessageInputType.MessageInputTypeDate.rawValue):
                        let entity =  NSEntityDescription.entity(forEntityName: "InputDate", in: managedObjectContext)
                        
                        let messageObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! InputDate
                        
                        if let senderInfo = inputModel.sender{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = senderInfo.id{
                                senderObject.id = id
                            }
                            
                            if let medium = senderInfo.medium{
                                senderObject.medium = medium
                            }
                            
                            senderObject.senderMessage = messageObject
                            messageObject.sender = senderObject
                        }
                        
                        if let receiverInfo = inputModel.recipient{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = receiverInfo.id{
                                recipientObject.id = id
                            }
                            
                            if let medium = receiverInfo.medium{
                                recipientObject.medium = medium
                            }
                            
                            recipientObject.recipientMessage = messageObject
                            messageObject.recipient = recipientObject
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let syncedWithServer = Int(inputModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        
                        if let sessionId = inputModel.sessionId{
                            messageObject.sessionId = sessionId
                        }
                        
                        if let messageTimeStamp = inputModel.messageTimeStamp{
                            messageObject.timestamp = messageTimeStamp
                        }
                        
                        if let messageDateStamp = inputModel.messageDateStamp{
                            messageObject.dateStamp = messageDateStamp
                        }
                        
                        if let senderType = inputModel.senderType{
                            messageObject.senderType = senderType
                        }
                        
                        if let messageType = inputModel.messageType{
                            messageObject.messageType = messageType
                        }
                        
                        messageObject.inputType = inputType
                        
                        if let inputInfo = inputModel.inputInfo as? NSDictionary{
                            messageObject.inputInfo = inputInfo
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let mandatory = inputModel.mandatory{
                            messageObject.mandatory = mandatory
                        }
                        
                        
                        if let inputAttributes = inputModel.inputAttributes as? InputDateModel{
                            let inputDateRangeEntity =  NSEntityDescription.entity(forEntityName: "DateRange", in: managedObjectContext)
                            let inputDateRangeObject = NSManagedObject(entity: inputDateRangeEntity!, insertInto: managedObjectContext) as! DateRange
                            if let minYear = inputAttributes.minYear{
                                inputDateRangeObject.minYear = minYear
                            }
                            if let minMonth = inputAttributes.minMonth{
                                inputDateRangeObject.minMonth = minMonth
                            }
                            if let minDay = inputAttributes.minDay{
                                inputDateRangeObject.minDay = minDay
                            }
                            if let maxYear = inputAttributes.maxYear{
                                inputDateRangeObject.maxYear = maxYear
                            }
                            if let maxMonth = inputAttributes.maxMonth{
                                inputDateRangeObject.maxMonth = maxMonth
                            }
                            if let maxDay = inputAttributes.maxDay{
                                inputDateRangeObject.maxDay = maxDay
                            }
                            if let interval = inputAttributes.interval{
                                inputDateRangeObject.interval = interval
                            }
                            inputDateRangeObject.inputDate = messageObject
                            messageObject.dateRange = inputDateRangeObject
                        }
                        
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            messageCompletion(messageObject)
                        }, failBlock: { (error) in
                            print("error")
                        })
                        
                    case Int16(MessageInputType.MessageInputTypeLocation.rawValue):
                        
                        let entity =  NSEntityDescription.entity(forEntityName: "InputLocation", in: managedObjectContext)
                        
                        let messageObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! InputLocation
                        
                        if let senderInfo = inputModel.sender{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = senderInfo.id{
                                senderObject.id = id
                            }
                            
                            if let medium = senderInfo.medium{
                                senderObject.medium = medium
                            }
                            
                            senderObject.senderMessage = messageObject
                            messageObject.sender = senderObject
                        }
                        
                        if let receiverInfo = inputModel.recipient{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = receiverInfo.id{
                                recipientObject.id = id
                            }
                            
                            if let medium = receiverInfo.medium{
                                recipientObject.medium = medium
                            }
                            
                            recipientObject.recipientMessage = messageObject
                            messageObject.recipient = recipientObject
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let syncedWithServer = Int(inputModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        
                        if let sessionId = inputModel.sessionId{
                            messageObject.sessionId = sessionId
                        }
                        
                        if let messageTimeStamp = inputModel.messageTimeStamp{
                            messageObject.timestamp = messageTimeStamp
                        }
                        
                        if let messageDateStamp = inputModel.messageDateStamp{
                            messageObject.dateStamp = messageDateStamp
                        }
                        
                        if let senderType = inputModel.senderType{
                            messageObject.senderType = senderType
                        }
                        
                        if let messageType = inputModel.messageType{
                            messageObject.messageType = messageType
                        }
                        
                        messageObject.inputType = inputType
                        
                        if let inputInfo = inputModel.inputInfo as? NSDictionary{
                            messageObject.inputInfo = inputInfo
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let mandatory = inputModel.mandatory{
                            messageObject.mandatory = mandatory
                        }
                        
                        
                        if let inputAttributes = inputModel.inputAttributes as? InputLocationModel{
                            
                            if let latitude = inputAttributes.latitude{
                                messageObject.latitude = latitude
                            }
                            if let longitude = inputAttributes.longitude{
                                messageObject.longitude = longitude
                            }
                        }
                        
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            messageCompletion(messageObject)
                        }, failBlock: { (error) in
                            print("error")
                        })
                    case Int16(MessageInputType.MessageInputTypeMedia.rawValue):
                        let entity =  NSEntityDescription.entity(forEntityName: "InputTypeMedia", in: managedObjectContext)
                        
                        let messageObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! InputTypeMedia
                        
                        if let senderInfo = inputModel.sender{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = senderInfo.id{
                                senderObject.id = id
                            }
                            
                            if let medium = senderInfo.medium{
                                senderObject.medium = medium
                            }
                            
                            senderObject.senderMessage = messageObject
                            messageObject.sender = senderObject
                        }
                        
                        if let receiverInfo = inputModel.recipient{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = receiverInfo.id{
                                recipientObject.id = id
                            }
                            
                            if let medium = receiverInfo.medium{
                                recipientObject.medium = medium
                            }
                            
                            recipientObject.recipientMessage = messageObject
                            messageObject.recipient = recipientObject
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let syncedWithServer = Int(inputModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        
                        if let sessionId = inputModel.sessionId{
                            messageObject.sessionId = sessionId
                        }
                        
                        if let messageTimeStamp = inputModel.messageTimeStamp{
                            messageObject.timestamp = messageTimeStamp
                        }
                        
                        if let messageDateStamp = inputModel.messageDateStamp{
                            messageObject.dateStamp = messageDateStamp
                        }
                        
                        if let senderType = inputModel.senderType{
                            messageObject.senderType = senderType
                        }
                        
                        if let messageType = inputModel.messageType{
                            messageObject.messageType = messageType
                        }
                        
                        messageObject.inputType = inputType
                        
                        if let inputInfo = inputModel.inputInfo as? NSDictionary{
                            messageObject.inputInfo = inputInfo
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let mandatory = inputModel.mandatory{
                            messageObject.mandatory = mandatory
                        }
                        
                        
                        if let inputAttributes = inputModel.inputAttributes as? InputMediaModel{
                            if let mediaType = inputAttributes.mediaType{
                                messageObject.mediaType = mediaType
                            }
                        }
                        
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            messageCompletion(messageObject)
                        }, failBlock: { (error) in
                            print("error")
                        })
                    case Int16(MessageInputType.MessageInputTypeAddress.rawValue):
                        let entity =  NSEntityDescription.entity(forEntityName: "InputAddress", in: managedObjectContext)
                        
                        let messageObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! InputAddress
                        
                        if let senderInfo = inputModel.sender{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = senderInfo.id{
                                senderObject.id = id
                            }
                            
                            if let medium = senderInfo.medium{
                                senderObject.medium = medium
                            }
                            
                            senderObject.senderMessage = messageObject
                            messageObject.sender = senderObject
                        }
                        
                        if let receiverInfo = inputModel.recipient{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = receiverInfo.id{
                                recipientObject.id = id
                            }
                            
                            if let medium = receiverInfo.medium{
                                recipientObject.medium = medium
                            }
                            
                            recipientObject.recipientMessage = messageObject
                            messageObject.recipient = recipientObject
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let syncedWithServer = Int(inputModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        
                        if let sessionId = inputModel.sessionId{
                            messageObject.sessionId = sessionId
                        }
                        
                        if let messageTimeStamp = inputModel.messageTimeStamp{
                            messageObject.timestamp = messageTimeStamp
                        }
                        
                        if let messageDateStamp = inputModel.messageDateStamp{
                            messageObject.dateStamp = messageDateStamp
                        }
                        
                        if let senderType = inputModel.senderType{
                            messageObject.senderType = senderType
                        }
                        
                        if let messageType = inputModel.messageType{
                            messageObject.messageType = messageType
                        }
                        
                        messageObject.inputType = inputType
                        
                        if let inputInfo = inputModel.inputInfo as? NSDictionary{
                            messageObject.inputInfo = inputInfo
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let mandatory = inputModel.mandatory{
                            messageObject.mandatory = mandatory
                        }
                        
                        if let requiredFields = inputModel.requiredFields{
                            messageObject.requiredFields = requiredFields
                        }
                        
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            messageCompletion(messageObject)
                        }, failBlock: { (error) in
                            print("error")
                        })
                    case Int16(MessageInputType.MessageInputTypeGetStarted.rawValue):
                        //retrieve the entity
                        let entity =  NSEntityDescription.entity(forEntityName: "Input", in: managedObjectContext)
                        
                        let messageObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Input
                        
                        if let senderInfo = inputModel.sender{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = senderInfo.id{
                                senderObject.id = id
                            }
                            
                            if let medium = senderInfo.medium{
                                senderObject.medium = medium
                            }
                            
                            senderObject.senderMessage = messageObject
                            messageObject.sender = senderObject
                        }
                        
                        if let receiverInfo = inputModel.recipient{
                            let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                            
                            let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                            
                            if let id = receiverInfo.id{
                                recipientObject.id = id
                            }
                            
                            if let medium = receiverInfo.medium{
                                recipientObject.medium = medium
                            }
                            
                            recipientObject.recipientMessage = messageObject
                            messageObject.recipient = recipientObject
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let syncedWithServer = Int(inputModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        
                        if let sessionId = inputModel.sessionId{
                            messageObject.sessionId = sessionId
                        }
                        
                        if let messageTimeStamp = inputModel.messageTimeStamp{
                            messageObject.timestamp = messageTimeStamp
                        }
                        
                        if let messageDateStamp = inputModel.messageDateStamp{
                            messageObject.dateStamp = messageDateStamp
                        }
                        
                        if let senderType = inputModel.senderType{
                            messageObject.senderType = senderType
                        }
                        
                        if let messageType = inputModel.messageType{
                            messageObject.messageType = messageType
                        }
                        
                        messageObject.inputType = inputType
                        
                        if let inputInfo = inputModel.inputInfo as? NSDictionary{
                            messageObject.inputInfo = inputInfo
                        }
                        
                        if let messageId = inputModel.messageId{
                            messageObject.messageId = messageId
                        }
                        
                        if let mandatory = inputModel.mandatory{
                            messageObject.mandatory = mandatory
                        }
                        
                        
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            messageCompletion(messageObject)
                        }, failBlock: { (error) in
                            print("error")
                        })
                    default:
                        print(inputModel)
                    }
                }
            }
            
            if let messageId = inputModel.messageId{
                let messagePredicate = NSPredicate(format: "(messageId == %@)",messageId)
                let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
                
                CoreDataContentManager.fetchRequest(withEntityName: "Message", predicate: messagePredicate, sortDescriptor: sortDescriptor, successBlock: { (fetchedObjects) in
                    if fetchedObjects.count == 0 {
                        createNewInput(successBlock: { (messageObject) in
                            successCompletion(messageObject)
                        })
                    }else{
                        let messageObject = fetchedObjects.first as! Message
                        if let timeStamp = inputModel.messageTimeStamp{
                            messageObject.timestamp = timeStamp
                        }
                        if let syncedWithServer = Int(inputModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        successCompletion(fetchedObjects.first as! Message)
                    }
                }) { (error) in
                }
            }else{
                createNewInput(successBlock: { (messageObject) in
                    successCompletion(messageObject)
                })
            }
        }
    }
    
    class func createOrUpdateExternal(withMessageInfo externalModel:ExternalMessageModel, successBlock successCompletion: @escaping (_ simpleObject: Message) -> Void,failBlock failCompletion: @escaping (_ error: Error?) -> Void){
        let managedObjectContext = CoreDataContentManager.backgroundObjectContext()
        managedObjectContext.perform { () -> Void in
            func createNewExternalMessage(successBlock messageCompletion: @escaping (_ simpleObject: Message) -> Void){
                //retrieve the entity
                let entity =  NSEntityDescription.entity(forEntityName: "External", in: CoreDataContentManager.managedObjectContext())
                
                let messageObject = NSManagedObject(entity: entity!, insertInto: CoreDataContentManager.managedObjectContext()) as! External
                
                if let senderInfo = externalModel.sender{
                    let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                    
                    let senderObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                    
                    if let id = senderInfo.id{
                        senderObject.id = id
                    }
                    
                    if let medium = senderInfo.medium{
                        senderObject.medium = medium
                    }
                    
                    senderObject.senderMessage = messageObject
                    messageObject.sender = senderObject
                }
                
                if let receiverInfo = externalModel.recipient{
                    let entity =  NSEntityDescription.entity(forEntityName: "Participant", in: managedObjectContext)
                    
                    let recipientObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! Participant
                    
                    if let id = receiverInfo.id{
                        recipientObject.id = id
                    }
                    
                    if let medium = receiverInfo.medium{
                        recipientObject.medium = medium
                    }
                    
                    recipientObject.recipientMessage = messageObject
                    messageObject.recipient = recipientObject
                }
                
                if let messageId = externalModel.messageId{
                    messageObject.messageId = messageId
                }
                
                if let sessionId = externalModel.sessionId{
                    messageObject.sessionId = sessionId
                }
                
                if let messageTimeStamp = externalModel.messageTimeStamp{
                    messageObject.timestamp = messageTimeStamp
                }
                
                if let messageDateStamp = externalModel.messageDateStamp{
                    messageObject.dateStamp = messageDateStamp
                }
                if let syncedWithServer = Int(externalModel.syncedWithServer) {
                    messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                }
                
                if let senderType = externalModel.senderType{
                    messageObject.senderType = senderType
                }
                
                if let contentJson = externalModel.externalPayload{
                    messageObject.contentJson = contentJson as? NSObject
                }
                
                if let messageType = externalModel.messageType{
                    messageObject.messageType = messageType
                }
                
                CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                    messageCompletion(messageObject)
                }, failBlock: { (error) in
                    print("error")
                })
            }
            
            if let messageId = externalModel.messageId{
                let messagePredicate = NSPredicate(format: "(messageId == %@)",messageId)
                let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
                
                CoreDataContentManager.fetchRequest(withEntityName: "Message", predicate: messagePredicate, sortDescriptor: sortDescriptor, successBlock: { (fetchedObjects) in
                    if fetchedObjects.count == 0 {
                        createNewExternalMessage(successBlock: { (messageObject) in
                            successCompletion(messageObject)
                        })
                    }else{
                        let messageObject = fetchedObjects.first as! Message
                        if let timeStamp = externalModel.messageTimeStamp{
                            messageObject.timestamp = timeStamp
                        }
                        
                        if let syncedWithServer = Int(externalModel.syncedWithServer) {
                            messageObject.syncedWithServer = NSNumber(value: syncedWithServer) as! Bool
                        }
                        successCompletion(fetchedObjects.first as! Message)
                    }
                }) { (error) in
                }
            }
        }
    }
    
    class func updateDataBaseWithResponseObject(_ responseObject :[String: Any], message : Message,successCompletion: @escaping (_ success: Bool) -> Void ){
        let inputModel = InputModel.init(responseObject)
        if let timeStamp = message.timestamp{
            getMessageObjectWithTimeStamp(timeStamp, successCompletion: { (messageObject) in
                if let messageId = inputModel.messageId{
                    messageObject.messageId = messageId
                }
                if let timeStamp = inputModel.messageTimeStamp{
                    messageObject.timestamp = timeStamp
                }
                messageObject.syncedWithServer = NSNumber(value: true) as! Bool
                CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                    successCompletion(true)
                }, failBlock: { (error) in
                    successCompletion(true)
                })
                print(messageObject)
            }, failCompletion: { (error) in
                print(error ?? Error.self)
            })
        }
    }
    
    class func getMessageObjectWithTimeStamp(_ timestamp : NSDate ,  successCompletion: @escaping (_ simpleObject: Message) -> Void , failCompletion: @escaping (_ error: Error?) -> Void){
        let predicate = NSPredicate(format: "(timestamp == %@)",timestamp)
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest(withEntityName: "Message", predicate: predicate, sortDescriptor: sortDescriptor, successBlock: { (fetchedObjects) in
            if fetchedObjects.count > 0 {
                successCompletion(fetchedObjects.first as! Message)
            }
        }) { (error) in
            failCompletion(error)
        }
    }
    
    class func getUnsentMessages() -> [Any]{
       
        let predicate = NSPredicate(format: "(syncedWithServer == NO)")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        return CoreDataContentManager.fetchRequest(withEntityName: "Message", predicate: predicate, sortDescriptor: sortDescriptor)
    }
    
    
    class func deleteAllWaitingPlaceholderImages(withCompletionBlock successCompletion: @escaping (_ success: Bool) -> Void ){
        
        let predicate = NSPredicate(format: "(messageType == %@)",NSNumber.init(value: Int16(MessageType.MessageTypeLoadingIndicator.rawValue)))
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)

        CoreDataContentManager.fetchRequest(withEntityName: "Message", predicate: predicate, sortDescriptor: sortDescriptor, successBlock: { (fetchedList) in
            if fetchedList.count == 0{
                successCompletion(true)
            }else{
                for i in 0 ..< fetchedList.count {
                    CoreDataContentManager.backgroundObjectContext().delete(fetchedList[i] as! NSManagedObject)
                    if i == fetchedList.count - 1{
                        CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                            successCompletion(true)
                        }, failBlock: { (error) in
                            successCompletion(true)
                        })
                    }
                }
            }
        }) { (error) in
            successCompletion(false)
        }
    }
    
    
    class func addWaitingPlaceholderCell(withCompletionBlock successCompletion: @escaping (_ success: Bool) -> Void ){
        func createPlaceholder(successBlock creationCompletion: @escaping (_ success: Bool) -> Void ){
            //retrieve the entity
            let entity =  NSEntityDescription.entity(forEntityName: "Message", in: CoreDataContentManager.managedObjectContext())
            
            let messageObject = NSManagedObject(entity: entity!, insertInto: CoreDataContentManager.managedObjectContext()) as! Message
            
            messageObject.messageId = UUID().uuidString
            messageObject.timestamp = NSDate.init(timeInterval: 1.0, since: Date())
            messageObject.messageType = Int16(MessageType.MessageTypeLoadingIndicator.rawValue)
            messageObject.senderType = Int16(MessageSenderType.MessageSenderTypeUser.rawValue)
            messageObject.syncedWithServer = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let strDate = dateFormatter.string(from: messageObject.timestamp! as Date)
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "yyyy-MM-dd"
            messageObject.dateStamp = strDate
            
            CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                creationCompletion(true)
            }, failBlock: { (error) in
                creationCompletion(false)
            })
        }
        CoreDataContentManager.deleteAllWaitingPlaceholderImages { (success) in
            createPlaceholder(successBlock: { (success) in
                successCompletion(success)
            })
        }
    }
    
    class func disableAllCardsLocallyStored(beforeTime date : NSDate ,successBlock successCompletion: @escaping (_ success: Bool) -> Void ){
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Message", in: CoreDataContentManager.managedObjectContext())
        
        // Initialize Batch Update Request
        let batchUpdateRequest = NSBatchUpdateRequest(entity: entityDescription!)
        let messagePredicate = NSPredicate(format: "(timestamp < %@ && productIoActionVisibilityStatus == %@)",date, NSNumber(value: true))
        batchUpdateRequest.predicate = messagePredicate
        // Coigure Batch Update Request
        batchUpdateRequest.resultType = .updatedObjectIDsResultType
        batchUpdateRequest.propertiesToUpdate = ["productIoActionVisibilityStatus": NSNumber(value: false)]
        
        do {
            // Execute Batch Request
            let batchUpdateResult = try CoreDataContentManager.managedObjectContext().execute(batchUpdateRequest) as! NSBatchUpdateResult
            
            // Extract Object IDs
            let objectIDs = batchUpdateResult.result as! [NSManagedObjectID]
            
            if objectIDs.count == 0 {
                successCompletion(true)
                return;
            }
            
            for objectID in objectIDs {
                // Turn Managed Objects into Faults
                if objectID == objectIDs.last {
                    // Turn Managed Objects into Faults
                    let managedObject = CoreDataContentManager.managedObjectContext().object(with: objectID)
                    if  !managedObject.isFault {
                        CoreDataContentManager.managedObjectContext().refresh(managedObject, mergeChanges: false)
                    }
                    
                    CoreDataContentManager.saveBackgroundContextWith(successBlock: { (success) in
                        successCompletion(true)
                    }, failBlock: { (error) in
                        successCompletion(true)
                    })
                }
            }
            
        } catch {
            successCompletion(false)
            let updateError = error as NSError
            print("\(updateError), \(updateError.userInfo)")
        }
    }
}
