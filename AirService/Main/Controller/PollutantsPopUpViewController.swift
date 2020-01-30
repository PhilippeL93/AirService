//
//  PollutantsPopUpViewController.swift
//  AirService
//
//  Created by Philippe on 23/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit
import FontAwesome_swift

// MARK: - class PollutantsPopUpViewController
class PollutantsPopUpViewController: UIViewController {

    // MARK: - outlets
    ///   link between view elements and controller
    ///
    @IBOutlet weak var buttonClose: UIButton!
    @IBAction func closePopUp(_ sender: UIButton) {
        self.removeAnimate()
        self.view.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        buttonClose.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        buttonClose.setTitle(String.fontAwesomeIcon(name: .timesCircle), for: .normal)
        self.showAnimate()
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
