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
            let error = NetworkError.invalidRequest
            print("[ProfileService.fetchProfile]: \(error) - токен: \(token)")
            completion(.failure(error))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let profileResult):
                    let name = [profileResult.firstName, profileResult.lastName]
                        .compactMap { $0 }
                        .joined(separator: " ")
                    let profile = Profile(
                        username: profileResult.username,
                        name: name.isEmpty ? profileResult.username : name,
                        loginName: "@\(profileResult.username)",
                        bio: profileResult.bio
                    )
                    self.profile = profile
                    completion(.success(profile))
                    
                case .failure(let error):
                    print("[ProfileService.fetchProfile]: \(error) - токен: \(token)")
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
