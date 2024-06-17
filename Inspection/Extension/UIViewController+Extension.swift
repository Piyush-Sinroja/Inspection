//
//  UIViewController+Extension.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import UIKit

// MARK: - UIViewController Extension
extension UIViewController {
    /// show alert
    /// - Parameters:
    ///   - title: title string
    ///   - message: message string
    ///   - okButtonTitle: ok button title
    ///   - okAction: ok button action handler
    func showAlert(withTitle title: String? = nil, andMessage message: String, okButtonTitle: String = Constant.Button.okButton, okAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // Handling OK action
        let okAction = UIAlertAction(title: okButtonTitle, style: .default) { _ in
            okAction?()
        }

        // Adding action buttons to the alert controller
        alert.addAction(okAction)

        DispatchQueue.main.async { [weak self] in
            // Presenting alert controller
            self?.present(alert, animated: true, completion: nil)
        }
    }
    /// show alert
    /// - Parameters:
    ///   - title: title string
    ///   - message: message string
    ///   - okButtonTitle: ok button title
    ///   - cancelButtonTitle: cancel button title
    ///   - okAction: ok button action handler
    ///   - cancelAction: cancel button action handler
    func showAlert(withTitle title: String = Constant.Common.appTitle, andMessage message: String, okButtonTitle: String = Constant.Button.okButton, cancelButtonTitle: String = Constant.Button.cancelButton, okAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        let okAction = UIAlertAction(title: okButtonTitle, style: .default) { _ in
            okAction?()
        }

        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
            cancelAction?()
        }

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

///
extension UIViewController {
    /// common alert controller
    func showAlert(_ title: String = Constant.Common.appTitle, message: String, buttonTitle: String) {
        DispatchQueue.main.async { [unowned self] in
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    /// common alert controller
    func showAlert(_ title: String = Constant.Common.appTitle, message: String, buttonTitle: String, completion: @escaping () -> Void) {
        DispatchQueue.main.async { [unowned self] in
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert )
            let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion()
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIViewController {
    func setLoading(_ loading: Bool) {
        if loading {
            CustomLoader.shared.showIndicator()
        } else {
            CustomLoader.shared.hideIndicator()
        }
    }
}
