//
//  LoginViewModel.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import Foundation

/// This class is used for loginc screen related api, validation and business logic
class LoginViewModel {
    
    // MARK: - Variables
    
    ///
    var email = ""
    ///
    var password = ""
    
    /// This is login model
    //var loginModel: LoginModel!
    
    // MARK: - API Call
    
    /// loginApi
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func loginApi(success: @escaping () -> Void, failure: @escaping (_ errorResponse: [String: Any]) -> Void) {
        let parameters = ["email": email,
                          "password": password]
        AlamofireApiService.shared().requestFor(modelType: EmptyEntity.self, apiType: ApiTypeConfiguration.login, param: parameters) { [weak self]
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
        if email.isEmpty && password.removeWhiteSpace().isEmpty {
            completion(false, Messages.LoginScreen.strEmailAndPassValidMsg)
        } else if email.removeWhiteSpace().isEmpty {
            completion (false, Messages.LoginScreen.strEmailIdMsg)
        } else if email.isValidEmail() == false {
            completion (false, Messages.LoginScreen.strValidEmailIdMsg)
        } else if password.removeWhiteSpace().isEmpty {
            completion (false, Messages.LoginScreen.strpasswordMsg)
        } else {
            completion (true, "")
        }
    }
}
