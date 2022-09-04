//
//  EditViewController.swift
//  ToDoListApp
//
//  Created by IACD-026 on 2022/09/01.
//

import UIKit

class EditViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var taskName: ToDoListItem?
    @IBOutlet weak var editTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        AssignFields(title: taskName!)
        editTextField.text = taskName?.name ?? ""
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        updateItem(item: taskName!, newName: editTextField.text ?? "")
        _ = navigationController?.popToRootViewController(animated: true)
        print("save button Pressed")
    }
    
    @IBAction func saveTest(_ sender: UIButton) {
        updateItem(item: taskName!, newName: editTextField.text ?? "")
        _ = navigationController?.popToRootViewController(animated: true)
        print("save button Pressed")
    }
    func AssignFields(title taskTitle: ToDoListItem ){
        taskName = taskTitle
    }
    
    func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
