//
//  SavedImagesVC.swift
//  SaveImageWithCoreData
//
//  Created by Vignesh on 31/01/19.
//  Copyright © 2019 Vignesh. All rights reserved.
//

import UIKit
import CoreData

class SavedImagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tblVw: UITableView!
    var imagePicker = UIImagePickerController()
    var pictures : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblVw.estimatedRowHeight = UITableView.automaticDimension
        tblVw.rowHeight = 180.0

        
    }
    
    func saveImageToCoreDate(image: NSData) {
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appdelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyPhotos", in: managedContext)!
        let photo = NSManagedObject(entity: entity, insertInto: managedContext)
        photo.setValue(image, forKey: "image")
        
        do {
            try managedContext.save()
            pictures.append(photo)
            print("My item == \(pictures.count)? ")
        } catch {
            debugPrint("Could not save... \(error.localizedDescription)")
        }
        
        
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "imagesCell", for: indexPath) as? ImagesCell else {return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let imageData: NSData = pickedImage.pngData()! as NSData
            saveImageToCoreDate(image: imageData)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            let imageData: NSData = image.pngData() as! NSData
            self.saveImageToCoreDate(image: imageData)
        })
        
    }
    
    */
   
}

