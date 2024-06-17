//
//  LoginViewController.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    ///
    @IBOutlet weak var emailTextfield: UITextField!
    ///
    @IBOutlet weak var passwordTextfield: UITextField!
    ///
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Variables
    
    ///
    private var activeTextfield: UITextField?
    
    ///
    private var loginViewModel = LoginViewModel()
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Initializing UI Methods
    
    ///
    func setupUI() {
        emailTextfield.setLeftPaddingPoints(10)
        passwordTextfield.setLeftPaddingPoints(10)
    }
    
    // MARK: - IBActions
    
    /// submit button action
    @IBAction func submitButtonAction(_ sender: Any) {
        loginViewModel.email = emailTextfield.text ?? "" // "test@gmail.com"
        loginViewModel.password =  passwordTextfield.text ?? "" // "test@123"
       
        // check login validation and call login api
        loginViewModel.validation { [weak self] (isValid, message) in
            guard isValid else {
                self?.showAlert(message: message, buttonTitle: Constant.Button.okButton, completion: {
                    self?.activeTextfield?.becomeFirstResponder()
                })
                return
            }
            self?.view.endEditing(true)
            self?.loginAPICall()
        }
    }
    
    // MARK: - API Methods
    
    /// callApi for login
    func loginAPICall() {
        self.setLoading(true)
        self.loginViewModel.loginApi(success: { [weak self] in
            self?.setLoading(false)
            guard let homeVC = self?.storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else { return }
            self?.navigationController?.pushViewController(homeVC, animated: true)
        }, failure: { [weak self] (responseDict) in
            self?.setLoading(false)
            if let message = responseDict[Constant.ResponseKeys.message] as? String {
                self?.showAlert(message: message, buttonTitle: Constant.Button.okButton)
            }
        })
    }
}
