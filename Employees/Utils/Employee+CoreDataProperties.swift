//
//  Employee+CoreDataProperties.swift
//  Employees
//
//  Created by Oussama Ayed on 13/12/2017.
//  Copyright © 2017 Oussama Ayed. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var salary: Double
    @NSManaged public var department: String?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var address: String?

}
