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
    private var unarch = [ToDoListItem]()

    var editIndexPath: Int?
    var selectedItem: ToDoListItem?


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task"
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        getAllItems()
    }
    
     @IBAction func didTapAdd () {
         let vc = storyboard?.instantiateViewController(withIdentifier: "Entry") as! EntryViewController
         vc.title = "New Task"
         navigationController?.pushViewController(vc , animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let model = models[indexPath.row]
       let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell
        
        cell?.setCell(isDone: model.isComplete)
        cell?.textLabel?.text = model.name
        cell?.isCompleteDelegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        selectedItem = models[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.editIndexPath = indexPath.row
            self.performSegue(withIdentifier: "Edit", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "Edit"{
            let destinationVC = segue.destination as? EditViewController
            destinationVC?.AssignFields(title: selectedItem!)
        }
    }

    
    
    //MARK: - Core Data

    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            //error
            print(error.localizedDescription)
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
    
    func toggleComplete(for index: Int) {
        models[index].isComplete.toggle()
        
        do {
            try context.save()
        }
        catch {
            
        }
        
    }
    
    
}
extension ViewController: isComplete{
    func toggleisComplete(for cell: UITableViewCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            toggleComplete(for: indexPath.row)
            tableView.reloadData()
            self.title = "Task"
        }
    }
}

