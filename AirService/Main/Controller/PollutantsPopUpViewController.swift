//
//  PollutantsPopUpViewController.swift
//  AirService
//
//  Created by Philippe on 23/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit

class PollutantsPopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.showAnimate()

        // Do any additional setup after loading the view.
    }

    @IBAction func closePopUp(_ sender: UIButton) {
        self.removeAnimate()
        self.view.removeFromSuperview()
    }

    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        )
    }

    func removeAnimate() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }
}
