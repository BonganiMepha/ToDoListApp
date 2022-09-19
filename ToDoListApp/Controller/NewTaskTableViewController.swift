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
    @IBOutlet weak var attachmentImageView: UIImageView!
    @IBOutlet weak var newTaskText: UITextField!
    var context: NSManagedObjectContext?
    var category: Category?
    var attchment: Data?
    
    
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
        newTodoListItem.attachment = attchment
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

extension NewTaskTableViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let attachmentsIndexPath = IndexPath(row: 0, section: 1)
    
    if indexPath == attachmentsIndexPath {
      let imagePickerController = UIImagePickerController()
      imagePickerController.delegate = self
      present(imagePickerController, animated: true, completion: nil)
    }
  }
}

extension NewTaskTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    guard let image = info[.originalImage] as? UIImage else { return }
    self.attachmentImageView.image = image
      self.attchment = image.pngData()
    // Customize
    
    dismiss(animated: true, completion: nil)
  }
}
