//
//  ViewController.swift
//  ToDoListApp
//
//  Created by IACD-026 on 2022/08/22.
//

import UIKit



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
 
    
     private var models = [ToDoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do List"
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Task", message: "Enter New Task", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        // weak self is so you dont create a memory weak
        alert.addAction(UIAlertAction(title: "Add", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.createItem(name: text)
            
        }))
        present(alert, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]

       // self.models.remove(at: indexPath.row)
       let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       cell.textLabel?.text = model.name
        
        cell.accessoryType = model.isComplete ? .checkmark: .none
        //cell.accessoryType = .checkmark
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        models[indexPath.row].isComplete = !models[indexPath.row].isComplete
        /* sheet.addAction(UIAlertAction(title: "Archive", style: .default, handler: { [weak self] _ in
            self?.deleteItem(item: item)
            
            
        }))*/
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }

        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = models[indexPath.row]
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
                
                let alert = UIAlertController(title: "Edit", message: "Edit your task", preferredStyle: .alert)
                
                alert.addTextField(configurationHandler: nil)
                alert.textFields?.first?.text = item.name
                alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                    guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                        return
                    }
                    
                    self?.updateItem(item: item, newName: newName)
                }))
                self.present(alert, animated: true)
            }))
            self.present(sheet, animated: true)
            
        }
        
        let archiveAction = UIContextualAction(style: .normal, title: "Archive"){(action, view, completion) in
            let item = self.models[indexPath.row]
            item.isArchived.toggle()
            tableView.reloadData()
            print(item.isArchived)
            do{
                try self.context.save()
            }
            catch{
                
            }
                
            }
            archiveAction.backgroundColor = .purple
        return UISwipeActionsConfiguration(actions: [editAction, archiveAction])
        
    }
    

    // Core Data
    
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
           
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            //error
        }
        
    
    }
    
    func createItem(name: String) {
        
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
        
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
    
    
    func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = models[indexPath.row]
        
        if item.isArchived {
            return 0
        }
        else{
            return 43.3
        }
    }
}

