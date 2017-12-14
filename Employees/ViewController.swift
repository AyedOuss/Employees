//
//  ViewController.swift
//  Employees
//
//  Created by Oussama Ayed on 13/12/2017.
//  Copyright © 2017 Oussama Ayed. All rights reserved.
//

import UIKit
import CoreData
import SwiftSpinner
class ViewController: UIViewController ,UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    var employees = [NSManagedObject]()
    func getEmployees()  {
        
        // If you plan to use Backendless Media Service, uncomment the following line (iOS ONLY!)
        // backendless.mediaService = MediaService()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let dataHelp = DataHelper(context: managedContext)
        dataHelp.seedMeteorites()
        
        
    }
    func fetchEmployees()  {
        SwiftSpinner.show("Get Data ...")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            self.employees = result as! [NSManagedObject]
            
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
            
            
        }
        SwiftSpinner.hide()
        
    }
    override func viewWillAppear(_ animated: Bool) {
       tableView.dataSource = self
        if (currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN){
            if !UserDefaults.standard.bool(forKey: "HasLaunchedOnce") {
                UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
                UserDefaults.standard.synchronize()
                getEmployees()
                
            }
            fetchEmployees()
        }else {
            fetchEmployees()
            if (employees.count == 0 ){
                
                let alert = UIAlertController(title: "No Network?!", message: "You need network connection for the first start to get data from Nasa", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction!) -> Void in
                    exit(0)
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        
        
        self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) //1.
       
        let employee = employees[indexPath.row] //2.
        let profilImage:UIImageView = cell.viewWithTag(1) as! UIImageView
        profilImage.image = UIImage(data: (employee.value(forKey: "photo") as! NSData) as Data)
        let lblName:UILabel = cell.viewWithTag(2) as! UILabel
        lblName.text = employee.value(forKey: "name") as? String
        let lblDepartment:UILabel = cell.viewWithTag(3) as! UILabel
        lblDepartment.text = employee.value(forKey: "department") as? String
        
        return cell //4.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? DetailsViewController {
            //do something you want
            let path = self.tableView.indexPathForSelectedRow!
            print("path : \(path.row)")
            let selectedRow:NSManagedObject = employees[path.row]
            destination.name = selectedRow.value(forKey: "name") as! String
            
        }
        
    }
    
}

