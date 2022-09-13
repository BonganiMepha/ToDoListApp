//
//  ImageCollectionViewCell.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/12.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var Myimage: UIImageView!
    @IBOutlet weak var imageText: UILabel!
    
    func setup(image: UIImage, text: String){
        Myimage.image = image
        imageText.text = text
    }
}
