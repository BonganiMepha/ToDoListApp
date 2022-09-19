//
//  EditTableViewController.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/08.
//

import UIKit

class EditTableViewController: UITableViewController {
    @IBOutlet weak var newTaskName: UITextField!
    @IBOutlet weak var newTaskDescription: UITextField!
    @IBOutlet weak var newTaskDate: UIDatePicker!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        newTaskDate.date = selectedDate
    }

    @IBAction func saveNewTaskAction(_ sender: Any) {
        guard let name = newTaskName ,
              let descrip = newTaskDescription,
              let curDate = newTaskDate else {
            fatalError("Could unwrap values")
        }
        
        createItem(name: name.text!, descrip: descrip.text!, date: curDate.date)
        navigationController?.popViewController(animated: true)
    }
    
    
    func createItem(name: String, descrip: String?, date: Date) {
        
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.taskDescription = descrip
        newItem.createdAt = date
        
        do {
            try context.save()
        
        }
        catch {
            
        }
        
    }
    

}
