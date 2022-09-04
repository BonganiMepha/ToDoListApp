//
//  EntryViewController.swift
//  ToDoListApp
//
//  Created by IACD-026 on 2022/09/01.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
 
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
    }
    @IBAction func saveTapped(_ sender: Any) {
        createItem(name: field.text!)
        navigationController?.popToRootViewController(animated: true)
    }
    func textFieldShouldReturn( _ textfield: UITextField) -> Bool  {
        saveTask()
       return true
    }
    
    @objc func saveTask() {
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
    }
    
    func createItem(name: String) {
        
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
        
        }
        catch {
            
        }
        
    }
}
