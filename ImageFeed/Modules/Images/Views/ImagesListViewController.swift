//
//  ImagesListViewController.swift.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 20.02.2025.
//

import UIKit
import Kingfisher


final class ImagesListViewController: UIViewController {
    
    // MARK: - Private Properties
    private let service: ImagesListServiceProtocol
    private var photos: [Photo] = []
    private let placeholderImage = UIImage(named: "image_placeholder")
    
    private lazy var tableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        element.dataSource = self
        element.delegate = self
        element.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        element.backgroundColor = UIConstants.Colors.blackColor
        element.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNotificationObserver()
        loadInitialPhotos()
        view.backgroundColor = UIConstants.Colors.blackColor
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(service: ImagesListServiceProtocol = ImagesListService.shared) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
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
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
    }
    
    private func loadInitialPhotos() {
        if photos.isEmpty {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
    
    @objc private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = ImagesListService.shared.photos.count
        photos = ImagesListService.shared.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private func handleLikeAction(for photoId: String) {
        guard let index = photos.firstIndex(where: { $0.id == photoId }) else { return }
        let currentLikeStatus = photos[index].isLiked
        
        ImagesListService.shared.changeLike(photoId: photoId, isLike: !currentLikeStatus) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                case .failure(let error):
                    print("Error changing like: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let photo = photos[indexPath.row]
        let date = Self.dateFormatter.string(from: Date())
        cell.showLoadingAnimation()
        
        cell.onLikeButtonTapped = { [weak self] photoId in
            self?.handleLikeAction(for: photoId)
        }
        cell.delegate = self
        
        cell.configure(with: photo, date: date)
        cell.selectionStyle = .none
        
        if let thumbImageURL = URL(string: photo.thumbImageURL) {
            cell.mainImage.kf.indicatorType = .activity
            cell.mainImage.kf.setImage(
                with: thumbImageURL,
                placeholder: placeholderImage,
                options: [
                    .transition(.fade(0.2))
                ],
                completionHandler: { [weak tableView] _ in
                    cell.removeGradientAnimation()
                    tableView?.reloadRows(at: [indexPath], with: .none)
                }
            )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < photos.count else { return 0 }
        
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / photo.size.width
        return photo.size.height * scale + imageInsets.top + imageInsets.bottom
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < photos.count else { return }
        let photo = photos[indexPath.row]
        let singleImageVC = SingleImageViewController()
        singleImageVC.photo = photo
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true)
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.photos = ImagesListService.shared.photos
                cell.setIsLiked(isLiked: !self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
