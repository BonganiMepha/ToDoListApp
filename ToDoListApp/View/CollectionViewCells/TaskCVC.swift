//
//  TaskCVC.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/13.
//

import UIKit

class TaskCVC: UICollectionViewCell {
    static let reuseIdentifier = String(describing: TagCVC.self)
    
    
    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskButton: UIButton!
    
    func setUp(desc: String, title: String, button: Bool){
        self.taskDescription.text = desc
        self.taskTitle.text = title
        self.taskButton.isEnabled = button
    }
}
