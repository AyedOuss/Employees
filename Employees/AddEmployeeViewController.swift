//
//  AddEmployeeViewController.swift
//  Employees
//
//  Created by Oussama Ayed on 14/12/2017.
//  Copyright © 2017 Oussama Ayed. All rights reserved.
//

import UIKit
import CoreData
class AddEmployeeViewController: UIViewController,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate  {
    var picker:UIImagePickerController?=UIImagePickerController()
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextView!
    @IBOutlet weak var txtDepartment: UITextField!
    @IBOutlet weak var txtSalary: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtAddress.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        txtAddress.layer.borderWidth = 1.0
        txtAddress.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
   
    @IBAction func openGallery(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source",preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "camera", style: .default, handler: {(action:UIAlertAction)in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: {(action:UIAlertAction)in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func saveEmployee(_ sender: UIButton) {
        //this is the line that appears to be wrong
        
        
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Employee",
                                       in: managedContext)!
        
        let employee = NSManagedObject(entity: entity,
                                           insertInto: managedContext)
        
        // 3
        if(txtName.text! == "" || txtAddress.text! == "" || txtSalary.text! == "" || txtDepartment.text! == "")
        {
            let alert = UIAlertController(title: "Missing information", message: "enter your name", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
    
            
        }else{
            let imageData = UIImagePNGRepresentation(profile.image!) as NSData?
            employee.setValue(imageData, forKeyPath: "photo")

            employee.setValue(txtName.text!, forKey: "name")
            
            employee.setValue(txtAddress.text!, forKey: "address")
            
            employee.setValue(txtDepartment.text!, forKey: "department")
            
            employee.setValue(Double(txtSalary.text!), forKey: "salary")
            // 4
            do {
                try managedContext.save()
                
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            self.navigationController?.popViewController(animated: true)
            
        }
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
         let imageData = UIImageJPEGRepresentation(image, 1)
        profile.image = UIImage(data: imageData!)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
