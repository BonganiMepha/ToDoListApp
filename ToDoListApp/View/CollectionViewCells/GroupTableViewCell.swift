//
//  GroupTableViewCell.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/15.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    static let resueseID = String(describing: GroupTableViewCell.self)
    @IBOutlet weak var GroupTextLabel: UILabel!
    @IBOutlet weak var groupCompletionBar: UIProgressView!
    
    func configure(with category: String, amount: Int = 100){
        self.GroupTextLabel?.text = category
        self.groupCompletionBar.setProgress(Float(amount / 10), animated: true)
        self.groupCompletionBar.tintColor = UIColor.white
        self.groupCompletionBar.backgroundColor = UIColor.black
    }
    
}
