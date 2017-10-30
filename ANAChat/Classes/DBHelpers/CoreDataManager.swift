//
//  CoreDataManager.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 11/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataManager: NSObject {
    static let sharedInstance = CoreDataManager()
    
    private lazy var applicationDocumentsDirectory: URL = {
        
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let bun = Bundle.init(for: type(of: self))
        
//        let podBundle = Bundle(for: NFCoreDataManager.self)
//        let bundleURL = podBundle.url(forResource: "NowFloats_iOSSDK", withExtension: "bundle")
//        let bundle = Bundle(url : bundleURL!)
        let modelURL = CommonUtility.getFrameworkBundle().url(forResource: "NowFloats_iOSSDK", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        objc_sync_enter(self)

        let url = self.applicationDocumentsDirectory.appendingPathComponent("NowFloats_iOSSDK.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            // Configure automatic migration.
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        objc_sync_exit(self);

        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        var managedObjectContext: NSManagedObjectContext?
        let coordinator = self.persistentStoreCoordinator
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext?.persistentStoreCoordinator = coordinator
        return managedObjectContext!
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        var privateContext : NSManagedObjectContext?
        let coordinator = self.persistentStoreCoordinator
        privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext?.parent = self.managedObjectContext
        privateContext?.stalenessInterval = 0
        return privateContext!
    }()
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}
