//
//  ImagesTableView.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 20.02.2025.
//

import UIKit
import Kingfisher

protocol ImagesTableViewDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
}

final class ImagesTableView: UIView {


    // MARK: - Private Properties
    var photos: [Photo] = []
    weak var delegate: ImagesTableViewDelegate?

    // MARK: - UI
    
    private let placeholderImage = UIImage(named: "0")
    
    private lazy var imagesTableView: UITableView = {
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
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupNotificationObserver()
        loadInitialPhotos()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadInitialPhotos() {
        if photos.isEmpty {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = ImagesListService.shared.photos.count
        photos = ImagesListService.shared.photos
        
        if oldCount != newCount {
            imagesTableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                imagesTableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
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
                    self?.imagesTableView.reloadRows(
                        at: [IndexPath(row: index, section: 0)],
                        with: .automatic
                    )
                case .failure(let error):
                    print("Error changing like: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let photo = photos[indexPath.row]
        let date = Self.dateFormatter.string(from: Date())
        
        cell.onLikeButtonTapped = { [weak self] photoId in
            self?.handleLikeAction(for: photoId)
        }
        cell.delegate = self 
        
        cell.configure(with: photo, date: date)
        
        if let thumbImageURL = URL(string: photo.thumbImageURL) {
            cell.mainImage.kf.indicatorType = .activity
            cell.mainImage.kf.setImage(
                with: thumbImageURL,
                placeholder: placeholderImage,
                options: [
                    .transition(.fade(0.2))
                ],
                completionHandler: { [weak tableView] _ in
                    tableView?.reloadRows(at: [indexPath], with: .none)
                }
            )
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            guard indexPath.row < photos.count else { return 0 }
            
            let photo = photos[indexPath.row]
            let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
            let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
            let scale = imageViewWidth / photo.size.width
            return photo.size.height * scale + imageInsets.top + imageInsets.bottom
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard indexPath.row < photos.count,
                  let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell,
                  let image = cell.mainImage.image else {
                return
            }
            delegate?.didSelectImage(image)
        }
    
}

extension ImagesTableView: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = imagesTableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
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


// MARK: - Set Views and Setup Constraints
private extension ImagesTableView {
    func setupViews() {
        addSubview(imagesTableView)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imagesTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imagesTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            imagesTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
