//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 28.03.2025.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private init() {}
    
    let urlString = "https://api.unsplash.com/me"
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeProfileRequest(token: token) else {
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
                        
                        let profile = Profile(
                            username: profileResult.username,
                            name: profileResult.firstName ?? "",
                            loginName: "@\(profileResult.username)",
                            bio: profileResult.bio
                        )
                        
                        self.profile = profile
                        completion(.success(profile))
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
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
