//
//  Conversation+CoreDataProperties.swift
//  SuperService
//
//  Created by Hanton on 10/31/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Conversation {

    @NSManaged var lastChat: String?
    @NSManaged var sessionID: String?
    @NSManaged var timestamp: NSDate?
    @NSManaged var otherSideName: String?
    @NSManaged var type: NSNumber?
    @NSManaged var unread: NSNumber?
    @NSManaged var otherSideID: String?

}
