//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 29.03.2025.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ) {
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeProfileImageRequest(username: username) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let profileResult = try decoder.decode(ProfileResult.self, from: data)
                        
                        if let smallImageURL = profileResult.profileImage?.small {
                            self.avatarURL = smallImageURL
                            completion(.success(smallImageURL))
                        } else {
                            completion(.failure(NetworkError.invalidRequest))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeProfileImageRequest(username: String) -> URLRequest? {
        guard let token = OAuth2TokenStorage.shared.token else {
            assertionFailure("No token available")
            return nil
        }
        
        let urlString = "https://api.unsplash.com/users/\(username)"
        guard let url = URL(string: urlString) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
