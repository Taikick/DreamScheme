//
//  ForTasks+CoreDataProperties.swift
//  
//
//  Created by 加藤　大起 on 2017/12/10.
//
//

import Foundation
import CoreData


extension ForTasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForTasks> {
        return NSFetchRequest<ForTasks>(entityName: "ForTasks")
    }

    @NSManaged public var cardDesign: String?
    @NSManaged public var created_at: TimeInterval
    @NSManaged public var doneID: Bool
    @NSManaged public var endDate: NSDate?
    @NSManaged public var forNotice: Bool
    @NSManaged public var id: Int16
    @NSManaged public var noticeHour: Int16
    @NSManaged public var startDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var totalDoneTime: Int32
    @NSManaged public var totalTime: Int32
    @NSManaged public var noticeMinute: Int16

}
