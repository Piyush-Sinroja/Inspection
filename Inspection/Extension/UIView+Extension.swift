//
//  UIView+Extension.swift
//  Inspection
//
//  Created by Piyush Sinroja on 15/06/24.
//

import UIKit

extension UIView {
    func setBorder(radius: CGFloat, color: UIColor = UIColor.clear) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
    }
}
