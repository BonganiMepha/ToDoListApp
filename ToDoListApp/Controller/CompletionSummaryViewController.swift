//
//  CompletionSummaryViewController.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/13.
//

import UIKit

class CompletionSummaryViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var modelTasks = [ToDoListItem]()
    
    @IBOutlet var completedTasksText : UILabel!
    @IBOutlet var overdueTasksText : UILabel!
    
    var completedItems  = 0
    var overdueItems = 0
    var totalItems = 0
    
    var completionWasCheck: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getAllItems()
        CompletedData()
    }
    
    
    func getAllItems() {
        do {
            modelTasks  = try context.fetch(ToDoListItem.fetchRequest())
        }
        catch {
            //error
            print(error.localizedDescription)
        }
    }
    
    func CompletedData(){
        
        totalItems = modelTasks.count
        
        for items in modelTasks {
            if items.isComplete{
                completedItems = 0
                completedItems += 1
            }
            else if items.createdAt ?? Date() < Date(){
                overdueItems = 0
                overdueItems += 1
            }
        }
        
        completedTasksText.text = " \(completedItems) / \(totalItems)"
        overdueTasksText.text = "\(overdueItems) / \(totalItems)"
    }
    
}
