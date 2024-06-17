//
//  RegisterViewController.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    
    ///
    @IBOutlet weak var emailTextfield: UITextField!
    ///
    @IBOutlet weak var passwordTextfield: UITextField!
    ///
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    ///
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Variables
    
    ///
    private var registerViewModel = RegisterViewModel()
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Initializing UI Methods
    
    /// setup method
    func setupUI() {
        passwordTextfield.setLeftPaddingPoints(10)
        emailTextfield.setLeftPaddingPoints(10)
        confirmPasswordTextfield.setLeftPaddingPoints(10)
    }
    
    // MARK: - IBActions
    
    /// submit button action
    @IBAction func submitButtonAction(_ sender: Any) {
       
        registerViewModel.email = emailTextfield.text?.removeWhiteSpace() ?? ""
        registerViewModel.password = passwordTextfield.text?.removeWhiteSpace() ?? ""
        registerViewModel.confirmPassword = confirmPasswordTextfield.text?.removeWhiteSpace() ?? ""
        
        // check login validation and call login api
        registerViewModel.validation { [weak self] (isValid, message) in
            guard isValid else {
                self?.showAlert(message: message, buttonTitle: Constant.Button.okButton)
                return
            }
            self?.view.endEditing(true)
            self?.registerAPICall()
        }
    }
    
    ///
    @IBAction func alredyRegisterButtonAction(_ sender: Any) {
        guard let loginVC = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else { return }
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
    // MARK: - API Methods
    
    /// callApi for login
    func registerAPICall() {
        setLoading(true)
        self.registerViewModel.registerApi(success: { [weak self] in
            self?.setLoading(false)
            guard let loginVC = self?.storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else { return }
            self?.navigationController?.pushViewController(loginVC, animated: true)
        }, failure: { [weak self] (responseDict) in
            self?.setLoading(false)
            if let message = responseDict[Constant.ResponseKeys.message] as? String {
                self?.showAlert(message: message, buttonTitle: Constant.Button.okButton)
            }
        })
    }
}
