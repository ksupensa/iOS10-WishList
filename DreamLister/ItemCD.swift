//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Spencer Forrest on 16/12/2016.
//  Copyright © 2016 Spencer Forrest. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        //TimeStamp: date of creation
        self.created = NSDate()
    }
}
