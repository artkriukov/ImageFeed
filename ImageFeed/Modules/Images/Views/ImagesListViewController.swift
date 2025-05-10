//
//  ImagesListViewController.swift.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 20.02.2025.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableViewAnimated()
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    // MARK: - Properties
    private var presenter: ImagesListPresenterProtocol!
    private let placeholderImage = UIImage(named: "image_placeholder")
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIConstants.Colors.blackColor
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupTableView()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func setupPresenter() {
        let service = ImagesListService.shared
        presenter = ImagesListPresenter(service: service)
        presenter.view = self
    }
    
    private func setupTableView() {
        view.backgroundColor = UIConstants.Colors.blackColor
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - ImagesListViewControllerProtocol
    func updateTableViewAnimated() {
        tableView.reloadData()
    }
    
    func showLoadingIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfPhotos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            assertionFailure("Failed to dequeue ImagesListCell")
            return UITableViewCell()
        }
        
        guard let photo = presenter.photo(at: indexPath.row) else {
            return cell
        }
        
        cell.configureLikeButton(isLiked: photo.isLiked)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    private func configureCell(_ cell: ImagesListCell, at indexPath: IndexPath) {
        guard let photo = presenter.photo(at: indexPath.row) else {
            assertionFailure("Photo not found at index \(indexPath.row)")
            return
        }
        
        cell.delegate = self
        cell.selectionStyle = .none
        cell.configure(
            with: photo,
            date: presenter.convertDate(photo: photo)
        )
        loadImage(for: cell, photo: photo)
    }
    
    private func loadImage(for cell: ImagesListCell, photo: Photo) {
        cell.showLoadingAnimation()
        
        guard let url = URL(string: photo.thumbImageURL) else {
            cell.mainImage.image = placeholderImage
            return
        }
        
        cell.mainImage.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [.transition(.fade(0.2))]
        ) { [weak cell] result in
            cell?.removeGradientAnimation()
            if case .failure = result {
                cell?.mainImage.image = self.placeholderImage
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter.photo(at: indexPath.row) else { return 0 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / photo.size.width
        return photo.size.height * scale + imageInsets.top + imageInsets.bottom
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.numberOfPhotos - 1 {
            presenter.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let photo = presenter.photo(at: indexPath.row) else { return }
        let singleImageVC = SingleImageViewController()
        singleImageVC.photo = photo
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true)
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let photo = presenter.photo(at: indexPath.row) else {
            assertionFailure("Failed to get photo for cell")
            return
        }
        presenter.changeLike(photoId: photo.id, isLike: !photo.isLiked)
    }
}
