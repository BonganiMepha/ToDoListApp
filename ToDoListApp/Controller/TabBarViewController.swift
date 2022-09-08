//
//  TabBarViewController.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/07.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ChangeApperance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.ChangeHeightOfTabbar()
    }
    
    //MARK - Tabbar customisation
    private func ChangeApperance(){
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.layer.cornerRadius = 30
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.tabBar.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        ChangeUnselectedColor()
    }
    private func ChangeUnselectedColor(){
        self.tabBar.unselectedItemTintColor = UIColor.gray.withAlphaComponent(0.5)
        self.tabBar.tintColor = UIColor.black
    }
    private func ChangeHeightOfTabbar(){
        if UIDevice().userInterfaceIdiom == .phone{
            var tabFrame = tabBar.frame
            tabFrame.size.height = 80
            tabFrame.origin.y = view.frame.size.height - 65
            tabBar.frame = tabFrame
        }
    }

}
