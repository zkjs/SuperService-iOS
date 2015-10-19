//
//  Order+CoreDataProperties.swift
//  SuperService
//
//  Created by Hanton on 10/19/15.
//  Copyright © 2015 ZKJS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Order {

    @NSManaged var duration: NSNumber?
    @NSManaged var roomType: String?
    @NSManaged var arrivalDate: String?
    @NSManaged var clientArrivalInfo: ClientArrivalInfo?

}
