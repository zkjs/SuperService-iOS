//
//  Persistence.swift
//  SVIP
//
//  Created by Hanton on 7/19/15.
//  Copyright (c) 2015 zkjinshi. All rights reserved.
//

import Foundation
import CoreData

class Persistence: NSObject {
  
  class func sharedInstance() -> Persistence {
    struct Singleton {
      static let instance = Persistence()
    }
    return Singleton.instance
  }
  
  var managedObjectContext: NSManagedObjectContext? = {
    // Initialize the managed object model
    let modelURL = NSBundle.mainBundle().URLForResource("SuperService", withExtension: "momd")
    let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!)
    
    // Initialize the persistent store coordinator
    let storeURL = Persistence.applicationDocumentsDirectory.URLByAppendingPathComponent("SuperService.sqlite")
    var error: NSError? = nil
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
    
    do {
      try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
    } catch var error1 as NSError {
      error = error1
      abort()
    } catch {
      fatalError()
    }
    
    // Initialize the managed object context
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    
    return managedObjectContext
  }()
  
  func saveContext() {
    if let managedObjectContext = self.managedObjectContext {
      if (managedObjectContext.hasChanges) {
        do {
          try managedObjectContext.save()
        } catch {
          abort()
        }
      }
    }
  }
  
  class var applicationDocumentsDirectory: NSURL {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.endIndex - 1] 
  }
  
  func deleteAllObjectsForEntityWithName(name: String) {
    print("Deleting all objects in entity \(name)")
    let fetchRequest = NSFetchRequest(entityName: name)
    fetchRequest.resultType = .ManagedObjectIDResultType
    
    if let managedObjectContext = managedObjectContext {
      let objectIDs: [AnyObject]?
      do {
        objectIDs = try managedObjectContext.executeFetchRequest(fetchRequest)
      } catch {
        objectIDs = nil
      }
      for objectID in objectIDs! {
        managedObjectContext.deleteObject(managedObjectContext.objectWithID(objectID as! NSManagedObjectID))
      }
      saveContext()
      print("All objects in entity \(name) deleted")
    }
  }
  
//  func saveClientArrivalInfoWithClient(client: Client, order: Order?, location: Location) {
//    let clientArrivalInfo = NSEntityDescription.insertNewObjectForEntityForName("ClientArrivalInfo",
//      inManagedObjectContext: self.managedObjectContext!) as! ClientArrivalInfo
//    clientArrivalInfo.clientID = client.ID
//    clientArrivalInfo.clientName = client.name
//    clientArrivalInfo.clientLevel = client.level
//    clientArrivalInfo.location = location.name
//    if let order = order {
//      clientArrivalInfo.roomType = order.roomType
//      clientArrivalInfo.duration = order.duration
//      clientArrivalInfo.arrivalDate = order.arrivalDate
//    }
//    saveContext()
//  }
  
  func fetchClientArrivalInfoArray() -> [ClientArrivalInfo]? {
    let fetchRequest = NSFetchRequest(entityName: "ClientArrivalInfo")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
    fetchRequest.fetchLimit = 7
    let clientArrivalInfoArray: [ClientArrivalInfo]
    do {
      clientArrivalInfoArray = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [ClientArrivalInfo]
      return clientArrivalInfoArray
    } catch let error as NSError {
      print("Fetch failed: \(error.localizedDescription)")
      return nil
    }
  }
  
  func fetchConversationArray() -> [Conversation]? {
    let fetchRequest = NSFetchRequest(entityName: "Conversation")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
    let conversationArray: [Conversation]
    do {
      conversationArray = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [Conversation]
      return conversationArray
    } catch let error as NSError {
      print("Fetch failed: \(error.localizedDescription)")
      return nil
    }
  }
  
  func saveConversationWithSessionID(sessionID: String, otherSideID: String, otherSideName: String, lastChat: String, timestamp: NSDate) {
    let fetchRequest = NSFetchRequest(entityName: "Conversation")
    fetchRequest.predicate = NSPredicate(format: "sessionID = %@", sessionID)
    do {
      if let results = try managedObjectContext?.executeFetchRequest(fetchRequest) as? [Conversation] {
        if results.count > 0 {
          // 已存在，更新
          if let conversation = results.first {
            conversation.sessionID = sessionID
            conversation.otherSideID = otherSideID
            conversation.otherSideName = otherSideName
            conversation.lastChat = lastChat
            conversation.timestamp = timestamp
            let oldUnread = conversation.unread!
            conversation.unread = NSNumber(integer: oldUnread.integerValue + 1)
            saveContext()
          }
        } else {
          // 未存在，插入
          let conversation = NSEntityDescription.insertNewObjectForEntityForName("Conversation",
            inManagedObjectContext: self.managedObjectContext!) as! Conversation
          conversation.sessionID = sessionID
          conversation.otherSideID = otherSideID
          conversation.otherSideName = otherSideName
          conversation.lastChat = lastChat
          conversation.timestamp = timestamp
          conversation.unread = NSNumber(integer: 1)
          saveContext()
        }
      }
    } catch let error as NSError {
      print("Something went wrong: \(error.localizedDescription)")
    }
  }
  
}
