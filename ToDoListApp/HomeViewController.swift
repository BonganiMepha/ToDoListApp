//
//  HomeViewController.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/12.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionVIew: UICollectionView!
     let dogImages:[UIImage] = Array(1 ... 11).map{UIImage(named: String($0))!}
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionVIew.collectionViewLayout = createLayout()
    }
    private func createLayout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout {(sectionNumber, env) -> NSCollectionLayoutSection? in
            if sectionNumber == 0{
                //item
                let item = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), spacing: 1)
                let fullItem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 1)
                let mainItem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(0.4), spacing: 1)
                
                //Group
                let verticalGroup = (CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(0.5), height: .fractionalHeight(1), item: fullItem, count: 2))
                let horizontalgroup = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.6), items: [item, verticalGroup])
                let mainGroup = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalHeight(0.5), items: [mainItem, horizontalgroup])
                
                //Section
                let section = NSCollectionLayoutSection(group: mainGroup)
                
                return section
            }else{
                let item = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), spacing: 1)
//                let fullItem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 1)
//                let mainItem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(0.4), spacing: 1)
                
                //Group
//                let verticalGroup = (CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(0.5), height: .fractionalHeight(1), item: fullItem, count: 2))
                let horizontalgroup = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.3), items: [item, item])
//                let mainGroup = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalHeight(0.5), items: [mainItem, horizontalgroup])
                
                //Section
                let section = NSCollectionLayoutSection(group: horizontalgroup)
                
                return section
            }

        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return dogImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _ = numberOfSections(in: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.setup(image: dogImages[indexPath.row])
        return cell
    }
}
