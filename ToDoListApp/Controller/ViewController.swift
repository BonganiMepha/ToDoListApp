//
//  ViewController.swift
//  ToDoListApp
//
//  Created by IACD-026 on 2022/08/22.
//

import UIKit

enum ViewsToShow: Int{
    case All = 0
    case Archived = 1
    case Done = 2
    case Overdue = 3
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var viewsToDisplay: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ToDoListItem]()
    private var unarch = [ToDoListItem]()
    private var done = [ToDoListItem]()
    var editIndexPath: Int?
    var selectedItem: ToDoListItem?
    var selectedView: ViewsToShow = .All
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task"
        getAllItems()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        viewsToDisplay.selectedSegmentIndex = selectedView.rawValue
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        getAllItems()
    }
    
    @IBAction func changeViewOnSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            selectedView = .All
            models = getSelectedItems(viewToShow: .All)
            tableView.reloadData()
        case 1:
            selectedView = .Archived
            models = getSelectedItems(viewToShow: .Archived)
            tableView.reloadData()
            //            print(models.count)
        case 2:
            selectedView = .Done
            models = getSelectedItems(viewToShow: .Done)
            tableView.reloadData()
            //            print(models.count)
        case 3:
            selectedView = .Overdue
            models = getSelectedItems(viewToShow: .Overdue)
            tableView.reloadData()
        default:
            return
        }
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
            try? self.context.save()
            tableView.reloadData()
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completion) in
            let deleteAlert = UIAlertController(title: "Are you sure", message: "are you sure you want to delete this task", preferredStyle: .alert)
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                let item = self.models[indexPath.row]
                self.models.remove(at: indexPath.row)
                self.context.delete(item)
                try? self.context.save()
                self.tableView.reloadData()
                
            }))
            self.present(deleteAlert, animated: true)
        }
        
        archiveAction.backgroundColor = .purple
        return UISwipeActionsConfiguration(actions: [editAction, archiveAction,deleteAction])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "Edit"{
            let destinationVC = segue.destination as? EditViewController
            destinationVC?.AssignFields(title: selectedItem!)
        }
    }
    
    
    
    //MARK: - Core Data
    
    func getSelectedItems(viewToShow: ViewsToShow) -> [ToDoListItem]{
        switch viewToShow {
        case .All:
            do {
                models = try context.fetch(ToDoListItem.fetchRequest())
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return models
            }
            catch {
                print(error.localizedDescription)
            }
        case .Archived:
            do {
                models = try context.fetch(ToDoListItem.fetchRequest())
                var unarry = models.filter { items in
                    return items.isArchived == true
                }
                return unarry
            }
            catch {
                print(error.localizedDescription)
            }
        case .Done:
            do {
                models = try context.fetch(ToDoListItem.fetchRequest())
                return models.filter { items in
                    items.isComplete == true
                }
            }
            catch {
                //error
                print(error.localizedDescription)
            }
        case .Overdue:
            do {
                models = try context.fetch(ToDoListItem.fetchRequest())
                return models.filter { items in
                    items.createdAt ?? Date() < Date()
                }
            }
            catch {
                //error
                print(error.localizedDescription)
            }
        default:
            return [ToDoListItem]()
        }
        return [ToDoListItem]()
    }
    
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
        }
    }
}

