//
//  HeaderView.swift
//  Inspection
//
//  Created by Piyush Sinroja on 15/06/24.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!

    /// animate image
    /// - Parameter isExpanded: isExpanded bool value
    func animateImage(isExpanded: Bool) {
      UIView.animate(withDuration: 0.3, animations: {
        self.imgview.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
      })
    }
}
