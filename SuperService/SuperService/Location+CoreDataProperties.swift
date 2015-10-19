//
//  Location+CoreDataProperties.swift
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

extension Location {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var clientArrivalInfo: ClientArrivalInfo?

}
