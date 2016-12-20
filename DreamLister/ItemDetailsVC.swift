   //
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Spencer Forrest on 17/12/2016.
//  Copyright © 2016 Spencer Forrest. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var thumbImage: UIImageView!
    
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
              topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }

        storePicker.delegate = self
        storePicker.dataSource = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ItemDetailsVC.dismissKeyboard))
        
        //Uncomment the line below if you want the tap to not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
//        generateTestData()
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row].name
        return store
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func getStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            self.stores = try ad.persistentContainer.viewContext.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle error 
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        var item: Item!
        let picture = Image(context: ad.persistentContainer.viewContext)
        picture.image = thumbImage.image
        
        
        if itemToEdit == nil {
            item = Item(context: ad.persistentContainer.viewContext)
        } else {
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            let numberCharacters = NSCharacterSet.decimalDigits.inverted
            if !price.isEmpty && price.rangeOfCharacter(from: numberCharacters) == nil {
                item.price = (price as NSString).doubleValue
            } else {
                // string contained non-digit characters
                item.price = 0.0
            }
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadItemData(){
        if let item = itemToEdit{
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as? UIImage
            
            // Set the right Component (field) and its row to UIViewPicker
            if let store = item.toStore {
                for index in 0...stores.count{
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                }
            }
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem){
        if itemToEdit != nil {
            ad.persistentContainer.viewContext.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            thumbImage.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func generateTestData(){
        let store = Store(context: ad.persistentContainer.viewContext)
        store.name = "Best Buy"
        let store2 = Store(context: ad.persistentContainer.viewContext)
        store2.name = "Amazon"
        let store3 = Store(context: ad.persistentContainer.viewContext)
        store3.name = "Costco"
        let store4 = Store(context: ad.persistentContainer.viewContext)
        store4.name = "Walmart"
        let store5 = Store(context: ad.persistentContainer.viewContext)
        store5.name = "E-bay"
        let store6 = Store(context: ad.persistentContainer.viewContext)
        store6.name = "Target"
        
        ad.saveContext()
    }
}
