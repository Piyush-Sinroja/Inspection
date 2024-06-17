//
//  Messages.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import Foundation

enum Messages {
    
    // MARK: - Login Screen Messages
    ///
    enum LoginScreen {
        ///
        static let strEmailAndPassValidMsg = "You must enter a valid email address and password."
        ///
        static let strEmailIdMsg = "Please enter an email address."
        ///
        static let strValidEmailIdMsg = "Please enter a valid email address."
        ///
        static let strpasswordMsg = "Please enter password."
        ///
        static let strValidpasswordMsg = "password must be at least 6 characters long."
        ///
        static let strConfirmPasswordMsg = "Please enter confirm password."
        ///
        static let strValidConfirmPasswordMsg = "password and confirm password does not match"
        ///
        static let strValidPhoneMsg = "Please enter valid phone no."
    }
    
    //
    enum HomeScreen {
        ///
        static let draftSaved = "Draft saved successfully"
        ///
        static let dataUploaded = "Data uploaded successfully"
        ///
        static let draftNotSaved = "Draft not saved"
    }
}
