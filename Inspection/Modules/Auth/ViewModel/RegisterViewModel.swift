//
//  RegisterViewModel.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import Foundation

class RegisterViewModel {
    
    // MARK: - Variables
    
    ///
    var email: String = ""
    ///
    var password: String = ""
    ///
    var confirmPassword: String = ""
    
    /// This is login model
    //var loginModel: LoginModel!
    // MARK: - API Call
    
    func  registerApi(success: @escaping () -> Void, failure: @escaping (_ errorResponse: [String: Any]) -> Void) {
        let parameters = ["email": email,
                          "password": password]
        AlamofireApiService.shared().requestFor(modelType: EmptyEntity.self, apiType: ApiTypeConfiguration.register, param: parameters) { [weak self]
            response in
            guard let weakSelf = self else {
                return
            }
            switch response {
            case .success(_):
                success()
            case .failure(let error):
                let errorRes: [String: Any] = ["message": error.localizedDescription]
                failure(errorRes)
            }
        }
    }
    
    // MARK: - Validation Login
    
    ///
    /// Validation for login
    ///
    /// - Parameter completion: completion return with bool and message string
    func validation(completion: @escaping (Bool, String) -> Void) {
        if email.removeWhiteSpace().isEmpty {
            completion (false, Messages.LoginScreen.strEmailIdMsg)
        } else if email.isValidEmail() == false {
            completion (false, Messages.LoginScreen.strValidEmailIdMsg)
        } else if password.removeWhiteSpace().isEmpty {
            completion (false, Messages.LoginScreen.strpasswordMsg)
        } else if password.removeWhiteSpace().count < 3 {
            completion (false, Messages.LoginScreen.strValidpasswordMsg)
        } else if confirmPassword.removeWhiteSpace().isEmpty {
            completion (false, Messages.LoginScreen.strConfirmPasswordMsg)
        } else if confirmPassword != password {
            completion (false, Messages.LoginScreen.strValidConfirmPasswordMsg)
        } else {
            completion (true, "")
        }
    }
}
