//
//  FetchPhotosUseCase.swift
//  PhotoPicsum
//
//  Created by ThienTran on 11/6/25.
//

import Foundation

protocol FetchPhotosUseCaseProtocol {
    func execute(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], Error>)  -> Void)
}

class FetchPhotosUseCase: FetchPhotosUseCaseProtocol {
    private let repository: PhotoRepositoryProtocol

    init(repository: PhotoRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], any Error>) -> Void) {
        repository.fetchPhotos(page: page, limit: limit, completion: completion)
    }
}
