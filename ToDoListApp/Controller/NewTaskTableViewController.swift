//
//  NewTaskTableViewController.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/15.
//

import UIKit
import CoreData

class NewTaskTableViewController: UITableViewController {

    @IBOutlet weak var newTaskDate: UIDatePicker!
    @IBOutlet weak var newTaskDescrip: UITextField!
    @IBOutlet weak var newTaskText: UITextField!
    var context: NSManagedObjectContext?
    var category: Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(category?.catName ?? "")")
        
    }


    
    @IBAction func AddNewTask(_ sender: Any) {
        guard let title = newTaskText.text else { return }
        guard let descrip = newTaskDescrip.text else { return }
        let date = newTaskDate.date
        guard let context = self.context else {return}
        guard let category = self.category else {return}
        
        
        let newTodoListItem = ToDoListItem(context: context)
        newTodoListItem.name = title
        newTodoListItem.taskDescription = descrip
        newTodoListItem.createdAt = date
        newTodoListItem.origin = category
        
//        newTodoListItem.list.catName = category.catName
//        newTodoListItem.list.todoListItem.insert(newTodoListItem)
        
        do{
          try context.save()
            navigationController?.dismiss(animated: true)
            print("ADDED")
        }catch{
         fatalError("New Reminder View Controller")
        }
    }
}
