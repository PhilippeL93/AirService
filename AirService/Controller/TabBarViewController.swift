//
//  TabBarViewController.swift
//  AirService
//
//  Created by Philippe on 16/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit
import FontAwesomeKit_Swift

class TabBarViewController: UITabBarController {

    var myTabBar = UITabBar()

    override func viewDidLoad() {
        super.viewDidLoad()
//        myTabBar.tintColor = UIColor.white
        tabBarItem.title = ""
        setTabBarItems()
    }

    func setTabBarItems() {
//        var newFrame = myTabBar.frame
//        newFrame.size.width = 24
//        newFrame.size.height = 24
//        myTabBar.frame = newFrame
//        let tabBarItemSize = __CGSizeEqualToSize(24, 24)
//let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
//        let tabBarWidth = tabBarController?.tabBar.frame.size.width ?? 0
//
//        tabBarController?.tabBar.frame.size.height = 15
//        tabBarController?.tabBarItem.
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(awesomeType: .search, size: 15)
        myTabBarItem1.title = "Villes"
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(awesomeType: .star, size: 15)
        myTabBarItem2.title = "Mes Villes"
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
}

//extension UITabBar {
//
//    override public func sizeThatFits(_ size: CGSize) -> CGSize {
//        super.sizeThatFits(size)
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 40
//        return sizeThatFits
//    }
//}
