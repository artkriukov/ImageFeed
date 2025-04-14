//
//  Extension+URLSession.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 29.03.2025.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case requestInProgress
    case invalidRequest
    case noImageURL
}

extension URLSession {
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void ) -> URLSessionTask {
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
                    print("Ошибка сети: HTTP Status Code \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Ошибка сети: Неизвестная ошибка сессии")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping(Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let responseData):
                do {
                    let decodedData = try decoder.decode(T.self, from: responseData)
                    completion(.success(decodedData))
                } catch {
                    print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: responseData, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Ошибка сети: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        return task
    }
}
