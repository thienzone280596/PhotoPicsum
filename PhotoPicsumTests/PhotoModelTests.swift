//
//  PhotoModelTests.swift
//  PhotoPicsumTests
//
//  Created by ThienTran on 12/6/25.
//

import XCTest

final class PhotoModelTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {

  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {

    }
  }

  func testPhotoModelDecoding() throws {
    let jsonData = """
          [
             {
                 "id": "0",
                 "author": "Alejandro Escamilla",
                 "width": 5000,
                 "height": 3333,
                 "url": "https://unsplash.com/photos/yC-Yzbqy7PY",
                 "download_url": "https://picsum.photos/id/0/5000/3333"
             }
          ]
          """.data(using: .utf8)!

    do {
      let photos = try JSONDecoder().decode([PhotoEntity].self, from: jsonData)
      XCTAssertEqual(photos.count, 1)
      XCTAssertEqual(photos[0].id, "0")
      XCTAssertEqual(photos[0].author, "Alejandro Escamilla")
      XCTAssertEqual(photos[0].width, 5000)
      XCTAssertEqual(photos[0].height, 3333)
      XCTAssertEqual(photos[0].url, "https://unsplash.com/photos/yC-Yzbqy7PY")
      XCTAssertEqual(photos[0].download_url, "https://picsum.photos/id/0/5000/3333")
    } catch {
      XCTFail("Decoding error: \(error)")
    }
  }

  func testPhotoModelDecodingFailure() throws {
    let invalidJsonData = """
      [
          {
              "identifier": "0",
              "creator": "Unknown",
              "size": "5000x3333",
              "link": "https://unsplash.com/photos/test",
              "image": "https://picsum.photos/id/0/5000/3333"
          }
      ]
      """.data(using: .utf8)!

    do {
      _ = try JSONDecoder().decode([PhotoEntity].self, from: invalidJsonData)
      XCTFail("Expected decoding to fail but it succeeded.")
    } catch {
      XCTAssertTrue(error is DecodingError, "Expected a DecodingError but got: \(type(of: error))")
    }
  }


}
