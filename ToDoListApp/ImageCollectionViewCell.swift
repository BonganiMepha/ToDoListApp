//
//  ImageCollectionViewCell.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/12.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var Myimage: UIImageView!
    
    func setup(image: UIImage){
        Myimage.image = image
    }
}
