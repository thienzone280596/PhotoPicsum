//
//  ViewController.swift
//  PhotoPicsum
//
//  Created by ThienTran on 11/6/25.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class PhotoListViewController: UIViewController {
  private var viewModel: PhotoListViewModel!
  var filteredPhotos: [PhotoEntity] = []
  let refreshControl = UIRefreshControl()
  let activityIndicator = UIActivityIndicatorView(style: .gray)

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var photoSearchBar: UISearchBar!

  // MARK: - Viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupTableView()
    self.setupViewModel()
    self.activityIndicator.startAnimating()
    self.viewModel.fetchPhotos()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }

  //Setup Tableview
  private func setupTableView() {
    self.tableView.register(UINib(nibName: PhotoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PhotoTableViewCell.identifier)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.refreshControl = refreshControl
    self.refreshControl.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
    self.tableView.tableFooterView = activityIndicator
  }

  //Setup ViewModel
  private func setupViewModel() {
    let repository = PhotoRepository()
    let fetchPhotosUseCase = FetchPhotosUseCase(repository: repository)
    let fetchSearchUseCase = FetchSearchUseCaseImpl()
    viewModel = PhotoListViewModel(fetchPhotsUseCase: fetchPhotosUseCase, fetchSearchUseCase: fetchSearchUseCase)
    viewModel.delegate = self
  }


  private func performSearch(with query: String) {
    filteredPhotos = viewModel.search(query: query)
    tableView.reloadData()
  }

  /// ReFresh Photo
  @objc private func refreshPhotos() {
    photoSearchBar.text = ""
    photoSearchBar.resignFirstResponder()
    viewModel.refreshPhotos()
    refreshControl.endRefreshing()
  }

  @objc func hideKeyboard() {
    view.endEditing(true)
  }
}

 // MARK: - UITableViewDelegate, UItableViewDatasource
@available(iOS 13.0, *)
extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredPhotos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as! PhotoTableViewCell
    cell.configure(with: filteredPhotos[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == viewModel.photos.count - 1 && viewModel.canLoadMore {
      activityIndicator.startAnimating()
      viewModel.fetchMorePhotos()
    }
  }
}

// MARK: - SearchBar
@available(iOS 13.0, *)
extension PhotoListViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    performSearch(with: searchText)
  }

  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let currentText = (searchBar.text as NSString?)?.replacingCharacters(in: range, with: text) ?? text
    let normalizedText = currentText.normalizedSearchText()
    if currentText != normalizedText {
      DispatchQueue.main.async {
        searchBar.text = normalizedText
        self.performSearch(with: normalizedText)
      }
      return false
    }
    return true
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}

// MARK: - Photo ListViewModel delegate
@available(iOS 13.0, *)
extension PhotoListViewController: PhotoListViewModelDelegate {
  func didUpdatePhotos() {
    // Update photo from view model to table when fetching from API success
    filteredPhotos = viewModel.photos
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()
      self.tableView.reloadData()
    }
  }

  func didFailWithError(_ error: any Error) {
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()
    }
    print(error)
  }
}
