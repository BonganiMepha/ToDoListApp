//
//  EntryViewController.swift
//  ToDoListApp
//
//  Created by IACD-026 on 2022/09/01.
//

import UIKit


class EntryViewController: UIViewController, UITextFieldDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [ToDoListItem]()
    private var date: Date = Date()
    
        
    
    
    
    @IBOutlet var field: UITextField!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet var descriptionTextField: UITextField!
    
   //
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet weak var dateWheels: UIDatePicker!
    
    static let dateFormatter: DateFormatter = {
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        
        return dateFormatter
    }()
   
    
    
    var indexPath: Int?
    let vc = ViewController()
    
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
           
            DispatchQueue.main.async {
                self.vc.tableView?.reloadData()
            }
        }
        catch {
            //error
        }
    
    }
    
    
   var update: (() -> Void)?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        descriptionTextField.delegate = self
        
        datePicker.setDate(Date(), animated: true)
        
        
        descriptionLabel.text = "Description"
       // dateLabel.text = Self.dateFormatter.string(from: models.date)
    
        
      //  navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
        
        
        // Do any additional setup after loading the view.
    }
    @objc func saveTapped(_ sender: Any) {
        createItem(name: field.text!)
      
        navigationController?.popToRootViewController(animated: true)
        
        
        
        if let text = field.text, !text.isEmpty {
            
           // let text = descriptionTextField.text, !text.isEmpty
            
            let date = datePicker.date
            
            do{
                try context.save()
                getAllItems()
            }
            catch{
                
            }
            
            
        }
        
        
    }
    func textFieldShouldReturn( _ textfield: UITextField) -> Bool  {
        
        saveTask()
        
       return true
    }
    @objc func saveTask() {
        
      /*  guard let text = field.text, !text.isEmpty else {
            return
        }
    guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        
        
        let newCount = count + 1
        
        UserDefaults().set(newCount, forKey: "count")
        UserDefaults().set(text, forKey: "task_ \(newCount)")*/
            
    }
    
    func createItem(name: String) {
        
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.date = Date()
        newItem.isArchived = false
        newItem.taskDescription = descriptionTextField.text
        
        
        do {
            try context.save()
        
        }
        catch {
            
        }
        
    }
    
    
}
