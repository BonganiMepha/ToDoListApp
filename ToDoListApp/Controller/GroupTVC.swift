//
//  GroupTVC.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/15.
//

import UIKit
import CoreData

class GroupTVC: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        //create the fetch request
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.fetchLimit = 20
        //sort Descriptor
        let sortDescriptior = NSSortDescriptor(key: "catName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptior]
        
        // section name key path can provide the titles for the table view if neeeded
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: self.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Could not fetch the results")
        }
        tableView.rowHeight = CGFloat(80)
        setupViews()
    }
    
    @IBAction func AddNewGroup(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Add New", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Group", style: .default, handler: { action in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewGroupView") as! NewGroupTableViewController
            self.navigationController?.pushViewController(vc , animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    private func setupViews() {
      navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "goToTodoItem":
            if let controller = (segue.destination as? UINavigationController)?.topViewController as? TaskTableViewController {
                controller.context = self.context
                guard let indexPath = tableView.indexPathForSelectedRow else {return}
                let category = fetchedResultsController.object(at: indexPath)
                controller.category = category
                controller.modalPresentationStyle = .fullScreen
//              handleShowDetailSegue(remindersViewController: controller)
            }
        default:
            return
        }
    }
}

extension GroupTVC{
    private func handleShowDetailSegue(remindersViewController: TaskTableViewController) {
      guard let indexPath = tableView.indexPathForSelectedRow else {
        return
      }
      // Prepare the context for detail view
      remindersViewController.context = self.context
      
      //pass the list along with to show the exact reminders
      //find the list tapped using the fetched result controller and then pass that list along
      
      let category = fetchedResultsController.object(at: indexPath)
        remindersViewController.category = category
    }
}

extension GroupTVC{
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {return 0}
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoryCell" , for: indexPath) as! GroupTableViewCell
        //takes an index path and returns an instance of fetched result
        let list = fetchedResultsController.object(at: indexPath)
        cell.configure(with: list.catName ?? "")
        
        return cell
    }
}

extension GroupTVC: NSFetchedResultsControllerDelegate{
    //this is called before the changes are about to be processed
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.beginUpdates()
    }
    
    //as the fetch results controller makes each change
    //notifies the delegate in the specific chnage in the the obeject
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
      guard let list  = anObject as? Category else {return}
      //switch on the type of operation the deledate is being called about
      switch type {
      case .insert:
        guard let newIndexPath = newIndexPath else { return }
        tableView.insertRows(at: [newIndexPath], with: .fade)
      case .delete:
        guard let indexPath = indexPath else {
          return
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
      case .move:
        //use the new index path and ask the table view to move the row to the current to new index path
        guard let indexPath = indexPath, let newIndexPath = newIndexPath else {
          return
        }
        tableView.moveRow(at: indexPath, to: newIndexPath)
      case .update:
        //get the cell at the index path and update it with the change
        guard let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? GroupTableViewCell else {
          return
        }
          cell.configure(with: list.catName ?? "")
        default:
        return
      }
    }
    
    //this is called once the changes are worked through
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.endUpdates()
    }
}
