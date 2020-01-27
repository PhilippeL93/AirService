//
//  CircleButtonView.swift
//  AirService
//
//  Created by Philippe on 23/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit

// MARK: - class CircleButtonView
class CircleButtonView: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
