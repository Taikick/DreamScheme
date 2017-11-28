//
//  ForTasks+CoreDataProperties.swift
//  
//
//  Created by 加藤　大起 on 2017/11/28.
//
//

import Foundation
import CoreData


extension ForTasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForTasks> {
        return NSFetchRequest<ForTasks>(entityName: "ForTasks")
    }

    @NSManaged public var doneID: Bool
    @NSManaged public var endDate: NSDate?
    @NSManaged public var created_at: TimeInterval
    @NSManaged public var startDate: NSDate?
    @NSManaged public var taskEndTime: NSDate?
    @NSManaged public var taskStartTime: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var id: Int16

}
