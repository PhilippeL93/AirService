//
//  TabBarViewController.swift
//  AirService
//
//  Created by Philippe on 16/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit
import FontAwesome_swift

// MARK: - class TabBarViewController
class TabBarViewController: UITabBarController {

    var myTabBar = UITabBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.title = ""
        setTabBarItems()
    }

    func setTabBarItems() {

        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage.fontAwesomeIcon(name: .search,
                                                      style: .solid,
                                                      textColor: UIColor.black,
                                                      size: CGSize(width: 40, height: 40))
        myTabBarItem1.title = "Villes"
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage.fontAwesomeIcon(name: .star,
                                                      style: .solid,
                                                      textColor: UIColor.black,
                                                      size: CGSize(width: 40, height: 40))
        myTabBarItem2.title = "Mes Villes"
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.image = UIImage.fontAwesomeIcon(name: .cog,
                                                      style: .solid,
                                                      textColor: UIColor.black,
                                                      size: CGSize(width: 40, height: 40))
        myTabBarItem3.title = "Paramètres"
        myTabBarItem3.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
