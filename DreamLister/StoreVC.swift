//
//  StoreVC.swift
//  WishList
//
//  Created by Spencer Forrest on 21/12/2016.
//  Copyright © 2016 Spencer Forrest. All rights reserved.
//

import UIKit
import CoreData

class StoreVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var storeNameField: CustomTextField!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    var stores = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storePicker.delegate = self
        storePicker.dataSource = self
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ItemDetailsVC.dismissKeyboard))
        //Uncomment the line below if you want the tap to not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        getStores()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return stores[row].name
        } else {
            return "Not the right Compoent"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let whitespaceSet = NSCharacterSet.whitespacesAndNewlines
        
        if let storeName = self.storeNameField.text {
            if !storeName.trimmingCharacters(in: whitespaceSet).isEmpty {
                // string contains non-whitespace characters
                let store = Store(context: ad.persistentContainer.viewContext)
                store.name = storeName
                
                ad.saveContext()
                
                //_ = navigationController?.popViewController(animated: true)
                
                getStores()
                storePicker.reloadAllComponents()
                
            } else {
                self.storeNameField.placeholder = "Please Enter a name"
            }
            self.storeNameField.text = nil
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        let index = storePicker.selectedRow(inComponent: 0)
        if stores.count > 0 {
            ad.persistentContainer.viewContext.delete(stores.remove(at: index))
            storePicker.reloadAllComponents()
        }
        
        storesVisibility()
    }
    
    func getStores() {
        let fetchedRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        fetchedRequest.sortDescriptors = [sortDescriptor]
        
        do {
            self.stores = try ad.persistentContainer.viewContext.fetch(fetchedRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        storesVisibility()
    }
    
    func storesVisibility(){
        if stores.count == 0 {
            storePicker.isHidden = true
            listLabel.isHidden = true
            deleteButton.isEnabled = false
        } else {
            storePicker.isHidden = false
            listLabel.isHidden = false
            deleteButton.isEnabled = true
        }
    }
}
