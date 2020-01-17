//
//  ViewQualityWhite.swift
//  AirService
//
//  Created by Philippe on 17/01/2020.
//  Copyright © 2020 Philippe. All rights reserved.
//

import UIKit

@IBDesignable

// MARK: class ViewYield
///    in order to
///    - put a border in color
///    - rounded corner
///
class ViewQualityWhite: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
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
