//
//  NetworkServiceTests.swift
//  PhotoPicsumTests
//
//  Created by ThienTran on 12/6/25.
//

import XCTest

final class NetworkServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

  func test_fetchData_success() {
         // Arrange
         let mockService = MockNetworkService()
         let expectedData = "{\"message\":\"success\"}".data(using: .utf8)!
         mockService.mockData = expectedData

         let url = URL(string: "https://picsum.photos/v2/list?page=1&limit=100")!
         let expectation = self.expectation(description: "FetchDataSuccess")

         // Act
         mockService.fetchData(from: url) { result in
             // Assert
             switch result {
             case .success(let data):
                 XCTAssertEqual(data, expectedData)
             case .failure:
                 XCTFail("Expected success, got failure")
             }
             expectation.fulfill()
         }

         waitForExpectations(timeout: 1.0)
     }

     func test_fetchData_failure() {
         // Arrange
         let mockService = MockNetworkService()
         let expectedError = NSError(domain: "TestError", code: 999)
         mockService.shouldReturnError = true
         mockService.mockError = expectedError

         let url = URL(string: "https://picsum.photos/v2/list?page=1&limit=100")!
         let expectation = self.expectation(description: "FetchDataFailure")

         // Act
         mockService.fetchData(from: url) { result in
             // Assert
             switch result {
             case .success:
                 XCTFail("Expected failure, got success")
             case .failure(let error as NSError):
                 XCTAssertEqual(error.domain, expectedError.domain)
                 XCTAssertEqual(error.code, expectedError.code)
             }
             expectation.fulfill()
         }

         waitForExpectations(timeout: 1.0)
     }

}
