//
//  HomeScreenAPIUnitTests.swift
//  InspectionTests
//
//  Created by Piyush Sinroja on 20/06/24.
//

import XCTest
@testable import Inspection

final class HomeScreenAPIUnitTests: XCTestCase {

    var homeViewModel: HomeViewModel?
    
    override func setUpWithError() throws {
        homeViewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        homeViewModel = nil
    }

    func testGetInspectionAPI() {
        homeViewModel?.getInspectionApi(success: { [weak self] in
            XCTAssert(true)
            XCTAssertNotNil(self?.homeViewModel?.cdInspectionData ?? nil)
        }, failure: { [weak self] errorStr in
            XCTAssert(false)
            XCTAssertNil(self?.homeViewModel?.cdInspectionData ?? nil)
            XCTAssertNotNil(errorStr)
        })
    }
    
    func testGetCDInspectionDataSuccess() {
        // test this after data dump into the coredata, otherwise it will always fail
        homeViewModel?.inspectionDataRepository.getCDInspectionData { [weak self] response in
            XCTAssertNotNil(response)
        }
    }
    
    func testGetCDInspectionDataFailedToFetch() {
        homeViewModel?.inspectionDataRepository.getCDInspectionData { [weak self] response in
            XCTAssertNil(response)
        }
    }
}
