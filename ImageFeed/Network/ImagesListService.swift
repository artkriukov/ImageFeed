//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 19.04.2025.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    private let perPage = 10
    private let urlSession = URLSession.shared
    private let dateFormatter = ISO8601DateFormatter()
    
    private init() {}
    
    func fetchPhotosNextPage() {
        guard currentTask == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        let request = makeRequest(page: nextPage, perPage: perPage)
        
        let task = urlSession.data(for: request) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let photoResults = try decoder.decode([PhotoResult].self, from: data)
                    
                    let newPhotos = photoResults.map { photoResult in
                        Photo(
                            id: photoResult.id,
                            size: CGSize(width: photoResult.width, height: photoResult.height),
                            createdAt: self.dateFormatter.date(from: photoResult.createdAt),
                            welcomeDescription: photoResult.description,
                            thumbImageURL: photoResult.urls.thumb,
                            largeImageURL: photoResult.urls.full,
                            isLiked: photoResult.likedByUser
                        )
                    }
                    
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: newPhotos)
                        self.lastLoadedPage = nextPage
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self
                        )
                        self.currentTask = nil
                    }
                } catch {
                    print("Failed to decode photos: \(error)")
                    DispatchQueue.main.async {
                        self.currentTask = nil
                    }
                }
            case .failure(let error):
                print("Failed to fetch photos: \(error)")
                DispatchQueue.main.async {
                    self.currentTask = nil
                }
            }
        }
        
        currentTask = task
        task.resume()
    }
    
    private func makeRequest(page: Int, perPage: Int) -> URLRequest {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/photos")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "order_by", value: "latest")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let urlString = "https://api.unsplash.com/photos/\(photoId)/like"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.data(for: request) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let likeResult = try decoder.decode(LikeResult.self, from: data)
                    
                    DispatchQueue.main.async {
                        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                            var updatedPhoto = self.photos[index]
                            updatedPhoto.isLiked = likeResult.photo.likedByUser
                            self.photos[index] = updatedPhoto
                            NotificationCenter.default.post(
                                name: ImagesListService.didChangeNotification,
                                object: self
                            )
                        }
                        completion(.success(()))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func cleanPhotos() {
        photos = []
    }
}

