//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Spencer Forrest on 16/12/2016.
//  Copyright © 2016 Spencer Forrest. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
