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

    // Outlets
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var pickedImgVw: UIImageView!
    
    // Variables
    var imagePicker = UIImagePickerController()
    var pictures : [NSManagedObject] = []
    var savedImage = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblVw.estimatedRowHeight = UITableView.automaticDimension
        tblVw.rowHeight = 180.0

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchResults()
    
      
    }
    
    func fetchResults() {
       
        pictures.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MyPhotos")
        
        //3
        do {
            pictures = try managedContext.fetch(fetchRequest)
            
            print("My item count == \(pictures.count) ")
            tblVw.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveImageToCoreDate(image: NSData) {
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appdelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyPhotos", in: managedContext)!
        let photo = NSManagedObject(entity: entity, insertInto: managedContext)
       // photo.setValue(image, forKey: "image")
        photo.setValue(image, forKeyPath: "image")
        
        do {
            try managedContext.save()
            //pictures.append(photo)
            fetchResults()
            
            print("My item count == \(pictures.count) ")
        } catch {
            debugPrint("Could not save... \(error.localizedDescription)")
        }
        
        
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "imagesCell", for: indexPath) as? ImagesCell else {return UITableViewCell()}
        let pic = pictures[indexPath.row] as NSManagedObject
        let imgData: Data = pic.value(forKey: "image") as! Data
       // let image : UIImage = UIImage(data: imgData, scale: 1.0)
        
        if let imageUrl = UIImage(data: imgData) {
            cell.favoriteImageView.image = imageUrl
        }
        
        //cell.favoriteImageView.image = UIImage(data: imgData as Data, scale: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
           // pickedImgVw.image = pickedImage
            
            let imageData: NSData = pickedImage.pngData()! as NSData
            print("My current item count == \(pictures.count)")
            saveImageToCoreDate(image: imageData)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

