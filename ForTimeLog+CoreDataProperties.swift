//
//  ForTimeLog+CoreDataProperties.swift
//  
//
//  Created by 加藤　大起 on 2017/12/10.
//
//

import Foundation
import CoreData


extension ForTimeLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForTimeLog> {
        return NSFetchRequest<ForTimeLog>(entityName: "ForTimeLog")
    }

    @NSManaged public var endTime: NSDate?
    @NSManaged public var id: Int16
    @NSManaged public var moveOrStop: Bool
    @NSManaged public var startTime: NSDate?
    @NSManaged public var taskID: Int16

}
