//
//  FetchSearchUseCase.swift
//  PhotoPicsum
//
//  Created by ThienTran on 12/6/25.
//
import Foundation

protocol FetchSearchUseCase {
    func search(photos: [PhotoEntity], query: String) -> [PhotoEntity]
}

class FetchSearchUseCaseImpl: FetchSearchUseCase {
    func search(photos: [PhotoEntity], query: String) -> [PhotoEntity] {
        guard !query.isEmpty else { return photos }
        let normalizedQuery = query.normalizedSearchText()
        print("normalizedQuery: \(normalizedQuery)")

        return photos.filter { photo in
            photo.author.lowercased().contains(normalizedQuery.lowercased()) ||
            photo.id.lowercased() == normalizedQuery.lowercased()
        }
    }
}

