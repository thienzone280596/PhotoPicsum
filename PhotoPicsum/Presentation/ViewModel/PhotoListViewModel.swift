//
//  PhotoListViewModel.swift
//  PhotoPicsum
//
//  Created by ThienTran on 11/6/25.
//

import Foundation

protocol PhotoListViewModelDelegate: AnyObject {
    func didUpdatePhotos()
    func didFailWithError(_ error: Error)
}

class PhotoListViewModel {

  var photos: [PhotoEntity] = []
  private var currentPage = 1
  private let limit = 100
  var isLoading = false
  var canLoadMore = false
  private let fetchPhotsUseCase: FetchPhotosUseCaseProtocol
  private let fetchSearchUseCase: FetchSearchUseCase
  //Delegate
  weak var delegate: PhotoListViewModelDelegate?


  init(fetchPhotsUseCase: FetchPhotosUseCaseProtocol, fetchSearchUseCase: FetchSearchUseCase) {
      self.fetchPhotsUseCase = fetchPhotsUseCase
      self.fetchSearchUseCase = fetchSearchUseCase
  }

  func fetchPhotos() {
      guard !isLoading else { return }
      isLoading = true
      fetchPhotsUseCase.execute(page: currentPage, limit: limit) { [weak self] result in
          guard let self = self else { return }
          self.isLoading = false
          switch result {
              case .success(let photos):
                  self.photos.append(contentsOf: photos)
                  canLoadMore = photos.count < limit ? false : true
                  self.delegate?.didUpdatePhotos()
              case .failure(let error):
                  self.delegate?.didFailWithError(error)
          }
      }
  }

  func search(query: String) -> [PhotoEntity] {
      return fetchSearchUseCase.search(photos: photos, query: query)
  }

  ///refresh photos
  func refreshPhotos() {
      currentPage = 1
      photos.removeAll()
      fetchPhotos()
  }

  func fetchMorePhotos() {
      self.currentPage += 1
      fetchPhotos()
  }
}
