//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 09.05.2025.
//

import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool)
    func convertDate(photo: Photo) -> String
    func photo(at index: Int) -> Photo?
    var numberOfPhotos: Int { get }
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private let service: ImagesListServiceProtocol
    private var photos: [Photo] = []
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .long
        return formatter
    }()
    
    init(service: ImagesListServiceProtocol = ImagesListService.shared) {
        self.service = service
        setupObservers()
    }
    
    var numberOfPhotos: Int {
        photos.count
    }
    
    func viewDidLoad() {
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        service.fetchPhotosNextPage()
    }
    
    func photo(at index: Int) -> Photo? {
        guard index < photos.count else { return nil }
        return photos[index]
    }
    
    func convertDate(photo: Photo) -> String {
        guard let date = photo.createdAt else { return "" }
        return dateFormatter.string(from: date)
    }
    
    func changeLike(photoId: String, isLike: Bool) {
        UIBlockingProgressHUD.show()
        service.changeLike(photoId: photoId, isLike: isLike) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                self.photos = self.service.photos
                self.view?.updateTableViewAnimated()
                
            case .failure(let error):
                print("Error changing like: \(error)")
            }
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updatePhotos()
        }
    }
    
    private func updatePhotos() {
        let newPhotos = service.photos
        photos = newPhotos
        view?.updateTableViewAnimated()
    }
}
