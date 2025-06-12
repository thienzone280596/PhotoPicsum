//
//  NetworkService.swift
//  PhotoPicsum
//
//  Created by ThienTran on 11/6/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()

  func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")

         #if DEBUG
      
         #endif

         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             if let error = error {
                 #if DEBUG
                 print("[Network Error] \(error.localizedDescription)")
                 #endif
                 completion(.failure(error))
                 return
             }

             guard let httpResponse = response as? HTTPURLResponse else {
                 let unknownError = NSError(domain: "NetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No valid HTTP response"])
                 completion(.failure(unknownError))
                 return
             }

             guard 200..<300 ~= httpResponse.statusCode else {
                 let statusError = NSError(domain: "NetworkService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error code: \(httpResponse.statusCode)"])
                 completion(.failure(statusError))
                 return
             }

             guard let data = data else {
                 let noDataError = NSError(domain: "NetworkService", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                 completion(.failure(noDataError))
                 return
             }

             #if DEBUG
             if let jsonString = String(data: data, encoding: .utf8) {
                 print("[Response JSON] \(jsonString)")
             } else {
                 print("[Response] Binary Data (non-UTF8)")
             }
             #endif

             completion(.success(data))
         }

         task.resume()
     }
}
