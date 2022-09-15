//
//  HomeViewController.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/12.
//

import UIKit
import CoreData

class DashBoardViewController: UIViewController {

    @IBOutlet weak var collectionVIew: UICollectionView!
     let dogImages:[UIImage] = Array(1 ... 11).map{UIImage(named: String($0))!}
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var HomeViewTasks = [ToDoListItem]()
    private var homeGroups = [Category]()
    static let categoryHeaderId = "categoryHeaderId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionVIew.collectionViewLayout = createLayout()
        collectionVIew.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: DashBoardViewController.categoryHeaderId, withReuseIdentifier: headerId)
        getAllItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionVIew.reloadData()
    }
    
    @IBAction func addNewToDash(_ sender: Any) {
        let ac = UIAlertController(title: "Add New", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Group", style: .default, handler: { action in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewGroupView") as! NewGroupTableViewController
            self.navigationController?.pushViewController(vc , animated: true)
            
        }))
        ac.addAction(UIAlertAction(title: "Task", style: .default, handler: { action in
            print("Go to new item view")
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        print(HomeViewTasks.count)
    }
    func getAllItems() {
        do {
            HomeViewTasks  = try context.fetch(ToDoListItem.fetchRequest())
            homeGroups = try context.fetch(Category.fetchRequest())
            DispatchQueue.main.async {
                self.collectionVIew.reloadData()
            }
        }
        catch {
            //error
            print(error.localizedDescription)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout {(sectionNumber, env) -> NSCollectionLayoutSection? in
            if sectionNumber == 0{
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 20
                item.contentInsets.leading = 20
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(220)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: DashBoardViewController.categoryHeaderId, alignment: .topLeading)
                ]
                return section
            }else if sectionNumber == 1{
                let item = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 20
                item.contentInsets.top = 20
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitems: [item, item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets.leading = 16
                section.contentInsets.bottom = 16
 
                return section
            }else{
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)))
                item.contentInsets.trailing = 16
                item.contentInsets.bottom = 16
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 16
                
                return section
            }
        }
    }
}

extension DashBoardViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if HomeViewTasks.count == 0 {
                return 0
            }else{
                return HomeViewTasks.count
            }
            
        }else if section == 2{
            return 3
        }else{
            if homeGroups.count == 0 {
                return 0
            }else{
                return homeGroups.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let model = HomeViewTasks[indexPath.row] 
//        let groupModel = homeGroups[indexPath.row]
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCV", for: indexPath) as! ImageCollectionViewCell
            cell.setup(text: String(indexPath.row))
//            cell.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
            cell.layer.cornerRadius = 10
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCV", for: indexPath) as! ImageCollectionViewCell
            cell.setup(text: String(indexPath.row))
            cell.layer.cornerRadius = 10
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCVC", for: indexPath) as! TaskCVC
            cell.setUp(desc: model.taskDescription ?? "", title: model.name ?? "", button: model.isComplete)
            cell.layer.cornerRadius = 10
            cell.contentView.backgroundColor = UIColor.gray

            return cell
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCV", for: indexPath) as! ImageCollectionViewCell
//            cell.setup(text: String(indexPath.row))
//            cell.layer.cornerRadius = 10
//            return cell
        default:
            return UICollectionViewCell()
        }
  
    }
}

final class TitleSupplementaryView: UICollectionReusableView{
    static let reuseIdentifier = String(describing: TitleSupplementaryView.self)
    
    let textLabel = UILabel()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        textLabel.text = "Category"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    private func configure(){
        addSubview(textLabel)
        textLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let inset: CGFloat = 10
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}
