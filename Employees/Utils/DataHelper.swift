//
//  DataHelper.swift
//  Employees
//
//  Created by Oussama Ayed on 13/12/2017.
//  Copyright © 2017 Oussama Ayed. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
import SwiftSpinner
class DataHelper {
    var ids = [Int16]()
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    internal func seedMeteorites() {
        
        SwiftSpinner.show("Get Date ...")
        let urlString:NSString = "http://testapp.mobilesoft.cz/api/employees"
        if let url = URL(string: urlString as String) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data)
                print(data)
                for result in json.arrayValue {
                    ids.append(result["id"].int16Value)
                }
            }
        }
        for id in ids {
            let urlemployee = "http://testapp.mobilesoft.cz/api/employees/\(id)"
            if let urle = URL(string: urlemployee as String) {
                if let dataEmployee = try? Data(contentsOf: urle){
                    let jsonEmployee = JSON(dataEmployee)
                    let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
                    employee.id = jsonEmployee["id"].int16Value
                    employee.name = jsonEmployee["name"].stringValue
                    employee.address = jsonEmployee["address"].stringValue
                    employee.salary = jsonEmployee["salary"].doubleValue
                    employee.department = jsonEmployee["department"].stringValue
                    if (jsonEmployee["photoUrl"].exists()){
                        let imageUrlString = "http://testapp.mobilesoft.cz\(jsonEmployee["photoUrl"].stringValue)"
                        let imageUrl:URL = URL(string: imageUrlString)!
                        let imageData:NSData = NSData(contentsOf: imageUrl)!
                        employee.photo = imageData
                    }else{
                        let imageData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "profil"), 1)
                        employee.photo = imageData! as NSData
                    }
                   
                }
            }
        }
        
            do {
                try context.save()
                
            } catch _ {
            }
        SwiftSpinner.hide()
        }
    }


