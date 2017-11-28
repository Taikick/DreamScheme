//
//  ForProcess+CoreDataProperties.swift
//  
//
//  Created by 加藤　大起 on 2017/11/28.
//
//

import Foundation
import CoreData


extension ForProcess {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForProcess> {
        return NSFetchRequest<ForProcess>(entityName: "ForProcess")
    }

    @NSManaged public var forTaskID: Int16
    @NSManaged public var id: Int16
    @NSManaged public var processEnd: NSDate?
    @NSManaged public var processSrart: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var processCard: String?
    @NSManaged public var weeklyProcess: String?
    @NSManaged public var dailyProcess: String?

}
