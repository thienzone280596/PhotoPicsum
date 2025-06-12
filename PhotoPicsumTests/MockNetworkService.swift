//
//  MockNetworkService.swift
//  PhotoPicsum
//
//  Created by ThienTran on 12/6/25.
//

import Foundation

class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    var mockData: Data?
    var mockError: Error?

    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(mockError ?? NSError(domain: "MockError", code: 0)))
        } else {
            completion(.success(mockData ?? Data()))
        }
    }
}
