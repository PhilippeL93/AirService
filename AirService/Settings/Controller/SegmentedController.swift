//
//  SegmentedController.swift
//  AirService
//
//  Created by Philippe on 20/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit

class SegmentedController: UISegmentedControl {

    var sortedViews: [UIView]!
    var currentIndex: Int = 0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        sortedViews = self.subviews.sorted(by: {$0.frame.origin.x < $1.frame.origin.x})
        changeSelectedIndex(to: currentIndex)
        self.tintColor = UIColor.white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        let unselectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                    NSAttributedString.Key.font:
                                        UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)]
        self.setTitleTextAttributes(unselectedAttributes, for: .normal)
        self.setTitleTextAttributes(unselectedAttributes, for: .selected)
    }

    func changeSelectedIndex(to newIndex: Int) {
        sortedViews[currentIndex].backgroundColor = UIColor.clear
        currentIndex = newIndex
        self.selectedSegmentIndex = UISegmentedControl.noSegment
    }
}
