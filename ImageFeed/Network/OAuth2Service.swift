//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 16.03.2025.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case requestInProgress
    case invalidRequest
}

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
                    completion(.failure(NetworkError.requestInProgress))
                    return
                } else {
                    task.cancel()
                }
            }
            
            self.lastCode = code
            
            guard let urlRequest = self.makeOAuthTokenRequest(code: code) else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
            
            let task = self.urlSession.data(for: urlRequest) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    self.task = nil
                    self.lastCode = nil
                    
                    switch result {
                    case .success(let data):
                        do {
                            let response = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                            OAuth2TokenStorage.shared.token = response.accessToken
                            completion(.success(response.accessToken))
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


extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}
