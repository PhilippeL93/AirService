//
//  PresentCitiesCell.swift
//  AirService
//
//  Created by Philippe on 26/12/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit

class PresentCitiesCell: UITableViewCell {

    @IBOutlet weak var citiesLabel: UITextField!
    @IBOutlet weak var qualityLabel: UITextField!

    // MARK: - function
    ///   function configure in order to display data in custom cell
    ///
    func configure(with city: String, quality: Int) {

        citiesLabel.text = city
        qualityLabel.text = String(quality)
    }
}
