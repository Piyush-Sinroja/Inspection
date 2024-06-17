//
//  Constant.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import Foundation
import UIKit

enum Constant {
    
    // MARK: - API Base Url
    
    enum API {
        static var baseURL: String = "http://127.0.0.1:5001/api"
    }
    
    
    // MARK: - Button title strings
    ///
    enum Button {
        ///
        static let okButton = "OK"
        ///
        static let cancelButton = "Cancel"
        ///
        static let yesButton = "Yes"
        ///
        static let noButton = "No"
    }

    // MARK: - Common strings
    ///
    enum Common {
        ///
        static let appTitle = "Inspection"
        ///
        static let strReqTimeOut = "The request timed out, Please try again."
        ///
        static let internetAlertMsg = "Please check your internet connection."
        ///
        static let tryAgain: String = "Please try again."
        ///
        static let somethingWrong = "Something went wrong."
    }

    static var keyWindow: UIWindow? {
        let allScenes = UIApplication.shared.connectedScenes
        for scene in allScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows where window.isKeyWindow {
                return window
            }
        }
        return nil
    }
    
    ///
    enum ApiHeaderKeys {
        static let contentType = "Accept"
        static let applicationOrJson = "application/json"
        static let multipartOrFormData = "multipart/form-data"
        static let token = "x-access-token"
    }
    
    /// response keys
    struct ResponseKeys {
        static let status = "status"
        static let data = "data"
        static let result = "result"
        static let message = "message"
    }
}

