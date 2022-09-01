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
        
      //  navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
        
        
        // Do any additional setup after loading the view.
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
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        
        
        let newCount = count + 1
        
        UserDefaults().set(newCount, forKey: "count")
        UserDefaults().set(text, forKey: "task_ \(newCount)")
            
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
