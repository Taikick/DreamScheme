//
//  ForTasks+CoreDataProperties.swift
//  
//
//  Created by 加藤　大起 on 2017/12/01.
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
    @NSManaged public var forSwitch: Bool
    @NSManaged public var id: Int16
    @NSManaged public var noticeDay: String?
    @NSManaged public var noticeWeek: String?
    @NSManaged public var purposeTime: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var taskImagePath: String?
    @NSManaged public var title: String?
    @NSManaged public var weekly: String?
    @NSManaged public var totalTime: NSDate?

}
