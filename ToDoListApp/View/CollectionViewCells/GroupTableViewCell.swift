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
    
    func configure(with category: String){
        self.GroupTextLabel?.text = category
    }
}
