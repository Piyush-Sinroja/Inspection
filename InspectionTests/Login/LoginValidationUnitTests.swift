//
//  InspectionTests.swift
//  InspectionTests
//
//  Created by Piyush Sinroja on 20/06/24.
//

import XCTest
@testable import Inspection

final class InspectionTests: XCTestCase {

    var loginViewModel: LoginViewModel?
    
    override func setUpWithError() throws {
        loginViewModel = LoginViewModel()
    }

    override func tearDownWithError() throws {
        loginViewModel = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testLoginEmailAndPasswordEmpty() {
        guard let loginViewModel else { return }
        loginViewModel.email = ""
        loginViewModel.password = ""
        let loginValidation = loginViewModel.validation()
        XCTAssertFalse(loginValidation.isValid)
        XCTAssertNotNil(loginValidation.message)
        XCTAssertEqual(loginValidation.message, Messages.LoginScreen.strEmailAndPassValidMsg)
    }
    
    func testLoginEmailEmpty() {
        guard let loginViewModel else { return }
        loginViewModel.email = ""
        loginViewModel.password = "tets@123"
        let loginValidation = loginViewModel.validation()
        XCTAssertFalse(loginValidation.isValid)
        XCTAssertNotNil(loginValidation.message)
        XCTAssertEqual(loginValidation.message, Messages.LoginScreen.strEmailIdMsg)
    }
    
    func testLoginEmailValidationScenario1() {
        guard let loginViewModel else { return }
        loginViewModel.email = "x"
        loginViewModel.password = "tets@123"
        let loginValidation = loginViewModel.validation()
        XCTAssertFalse(loginValidation.isValid)
        XCTAssertNotNil(loginValidation.message)
        XCTAssertEqual(loginValidation.message, Messages.LoginScreen.strValidEmailIdMsg)
    }
    
    func testLoginEmailValidationScenario2() {
        guard let loginViewModel else { return }
        loginViewModel.email = "x"
        loginViewModel.password = "tets@123"
        let loginValidation = loginViewModel.validation()
        XCTAssertFalse(loginValidation.isValid)
        XCTAssertNotNil(loginValidation.message)
        XCTAssertEqual(loginValidation.message, Messages.LoginScreen.strValidEmailIdMsg)
    }
    
    func testLoginEmailValidationScenario3() {
        guard let loginViewModel else { return }
        loginViewModel.email = "x@gmail"
        loginViewModel.password = "tets@123"
        let loginValidation = loginViewModel.validation()
        XCTAssertFalse(loginValidation.isValid)
        XCTAssertNotNil(loginValidation.message)
        XCTAssertEqual(loginValidation.message, Messages.LoginScreen.strValidEmailIdMsg)
    }
    
    func testLoginEmailValidationScenario4() {
        guard let loginViewModel else { return }
        loginViewModel.email = "x@gmail.com"
        loginViewModel.password = "tets@123"
        let loginValidation = loginViewModel.validation()
        XCTAssertTrue(loginValidation.isValid)
        XCTAssertEqual(loginValidation.message, "")
    }
}
