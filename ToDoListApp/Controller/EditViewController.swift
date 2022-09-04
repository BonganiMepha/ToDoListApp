//
//  EditViewController.swift
//  ToDoListApp
//
//  Created by IACD-026 on 2022/09/01.
//

import UIKit

class EditViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    private var models = [ToDoListItem]()
    var indexPath: Int?
    let vc = ViewController()
    
    
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
           
            DispatchQueue.main.async {
                self.vc.tableView?.reloadData()
            }
        }
        catch {
            //error
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
       
        
        
        
       
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveEditedButton(_ sender: Any) {
        let item = models[indexPath!]
        print(item)
        
    }
}
