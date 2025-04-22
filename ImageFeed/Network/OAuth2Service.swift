//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 16.03.2025.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    private let decoder = JSONDecoder()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.main.async {
            if let task = self.task {
                if self.lastCode == code {
                    let error = NetworkError.requestInProgress
                    print("[OAuth2Service.fetchOAuthToken]: \(error) - код уже в обработке: \(code)")
                    completion(.failure(error))
                    return
                } else {
                    task.cancel()
                }
            }
            guard let urlRequest = self.makeOAuthTokenRequest(code: code) else {
                let error = NetworkError.invalidRequest
                print("[OAuth2Service.fetchOAuthToken]: \(error) - неверный запрос для кода: \(code)")
                completion(.failure(error))
                return
            }
            
            let task = self.urlSession.objectTask(for: urlRequest) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                DispatchQueue.main.async {
                    guard let self else { return }
                    
                    self.task = nil
                    self.lastCode = nil
                    
                    switch result {
                    case .success(let response):
                        OAuth2TokenStorage.shared.token = response.accessToken
                        completion(.success(response.accessToken))
                    case .failure(let error):
                        print("[OAuth2Service.fetchOAuthToken]: \(error) - код: \(code)")
                        completion(.failure(error))
                    }
                }
            }
            
            self.task = task
            task.resume()
        }
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let urlString = AuthViewConstants.unsplashAuthorizeURLString
        
        guard var urlComponents = URLComponents(string: urlString) else {
            assertionFailure("Неверный URL: \(urlString)")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        print(code)
        
        guard let url = urlComponents.url else {
            assertionFailure("Неверный URL: \(urlComponents)")
            return nil
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print(request)
        return request
    }
}

