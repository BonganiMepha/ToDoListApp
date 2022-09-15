//
//  NewTaskTableViewCell.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/15.
//

import UIKit
import CoreData

class NewTaskTableViewCell: UITableViewCell {
    
    
    @IBOutlet var taskTitle: UILabel!
    
    
    func configure(for title: String ){
        taskTitle.text = title
    }

}
