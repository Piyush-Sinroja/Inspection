//
//  CustomLoader.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import UIKit

public class CustomLoader {
    public static let shared = CustomLoader()
    var blurImg = UIImageView()
    var indicator = UIActivityIndicatorView()

    private init() {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.5
        indicator.style = .large
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = .red
    }

    /// show indicator
    func showIndicator() {
        DispatchQueue.main.async {
            Constant.keyWindow?.addSubview(self.blurImg)
            Constant.keyWindow?.addSubview(self.indicator)
        }
    }
    
    /// hide indicator
    func hideIndicator() {
        DispatchQueue.main.async {
            self.blurImg.removeFromSuperview()
            self.indicator.removeFromSuperview()
        }
    }
}

