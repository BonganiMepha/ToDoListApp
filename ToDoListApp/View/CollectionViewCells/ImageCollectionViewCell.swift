//
//  ImageCollectionViewCell.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/12.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageText: UILabel!
    
    func setup(text: String){
        
        imageText.text = text
    }
}
