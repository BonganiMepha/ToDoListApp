//
//  TaskTableViewController.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/15.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController {
//    var contxt = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var context: NSManagedObjectContext?
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
          try fetchedResultsController.performFetch()
        }catch{
          fatalError("Core Data in Reminder")
        }
        navigationItem.title = "\(category?.catName ?? "") Tasks"
        

        print("\(fetchedResultsController.fetchedObjects?.count)")
    }
    
    //snapshot provided with the argument to apply with the data source
    func  controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
      let reminderSnapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
      dataSource.apply(reminderSnapshot)
    }
    

    @IBAction func NewTaskAction(_ sender: Any) {
        
    }
    
    //fetch reminders from the data store
   private lazy var fetchedResultsController: NSFetchedResultsController<ToDoListItem> = {
     let fetchRequest: NSFetchRequest<ToDoListItem> = ToDoListItem.fetchRequest()
     let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
     fetchRequest.sortDescriptors = [sortDescriptor]
     //Predicate
     // Fetch only the reminders that match this list
       let predicate  = NSPredicate(format: "%K == %@", "origin.catName", self.category!.catName)
     fetchRequest.predicate = predicate
     
       let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context! , sectionNameKeyPath: nil, cacheName: nil)
     
     frc.delegate = self
     return frc
     
   }()
    
    lazy var dataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> = {
      let dataSource = UITableViewDiffableDataSource<String, NSManagedObjectID>(tableView: tableView) { (tableView, indexPath, objectId) -> UITableViewCell? in
        //retrive instance of reminder
        //Using NSmanagedObeject
        guard let todoListItem = try? self.context?.existingObject(with: objectId) as? ToDoListItem else {return nil}
        let cell = UITableViewCell(style: .default, reuseIdentifier: "taskCell")
          cell.textLabel?.text = todoListItem.name
        return cell
      }
      tableView.dataSource = dataSource
      return dataSource
      //The snapshot is handleded by the fetch results controller
      //when the fetch results controller tells its contents that is has changed it will update the snapshot
  }()
    

}
extension TaskTableViewController:NSFetchedResultsControllerDelegate{
    
}
// MARK: - Setup Code -



extension TaskTableViewController{
    private func handleAddNewTaskSegue(newTaskViewController: NewTaskTableViewController) {
      // Prepare the context
        newTaskViewController.context = context.self
        newTaskViewController.category = category.self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTaskEntry"{
            if let controller = (segue.destination as? UINavigationController)?.topViewController as? NewTaskTableViewController{
                handleAddNewTaskSegue(newTaskViewController: controller)
            }
        }
    }
}
extension TaskTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
      return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

