//
//  NewGroupTableViewController.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/14.
//

import UIKit

class NewGroupTableViewController: UITableViewController {

    @IBOutlet weak var groupDescriptionText: UITextField!
    @IBOutlet weak var groupNameText: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveGroup))
        
    }

    
    @objc func saveGroup(){
        guard let groupName = groupNameText.text else {return}
        let newGroup  = Category(context: context)
        newGroup.catName = groupName
        do{
            try context.save()
        }catch{
            fatalError("Category Could not be saved")
        }
        navigationController?.popViewController(animated: true)
    }
    
}
