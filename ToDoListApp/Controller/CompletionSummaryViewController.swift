//
//  CompletionSummaryViewController.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/13.
//

import UIKit

class CompletionSummaryViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var completedTasks = [ToDoListItem]()
    
    @IBOutlet weak var summaryText: UILabel!
    var completedItems  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        summaryText.text = String(completedItems)
        getAllItems()
        CompletedData()
    }


    func getAllItems() {
        do {
            completedTasks  = try context.fetch(ToDoListItem.fetchRequest())
        }
        catch {
            //error
            print(error.localizedDescription)
        }
    }
    
    func CompletedData(){
        for items in completedTasks {
            if items.isComplete{
                if completedItems == completedItems {
                    print(completedItems)
                }else{
                    completedItems += 1
                }
            }
            print(completedItems)
        }
        
    }
    
}
