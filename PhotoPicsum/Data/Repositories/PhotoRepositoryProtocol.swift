//
//  PhotoRepository.swift
//  PhotoPicsum
//
//  Created by ThienTran on 11/6/25.
//

import Foundation

protocol PhotoRepositoryProtocol {
    func fetchPhotos(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], Error>) -> Void )
}

class PhotoRepository: PhotoRepositoryProtocol {
    private let networkService: NetworkService

    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }

    func fetchPhotos(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], any Error>) -> Void) {
        guard let url = APIEndpoints.photos(page: page, limit: limit) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        networkService.fetchData(from: url) { result in
            switch result {
                case .success(let data):
                do {
                    let photos = try JSONDecoder().decode([PhotoEntity].self, from: data)
                    completion(.success(photos))
                } catch {
                    completion(.failure(error))
                }
                case .failure(let error):
                completion(.failure(error))

            }
        }
    }
}
