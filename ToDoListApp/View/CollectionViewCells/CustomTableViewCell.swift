//
//  CustomTableViewCell.swift
//  ToDoListApp
//
//  Created by IACD-026 on 2022/08/31.
//

import UIKit
protocol isComplete {
    func toggleisComplete ( for cell: UITableViewCell)
}

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var isCompleted: UIButton!
    var isCompleteDelegate: isComplete?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setCell(isDone: Bool) {
        if isDone{
            isCompleted.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
        }else{
            isCompleted.setImage(UIImage(systemName: "seal"), for: .normal)
        }
    }

    @IBAction func isCompleteButton(_ sender: Any) {
        isCompleteDelegate?.toggleisComplete(for: self)
    }
}
