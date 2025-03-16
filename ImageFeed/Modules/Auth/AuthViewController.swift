//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 14.03.2025.
//

import UIKit

enum AuthViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/token"
}

final class AuthViewController: UIViewController {
    
    // MARK: - Private Properties
    private let authView = AuthView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = authView
        authView.delegate = self
        
        configureBackButton()
    }
    
    // MARK: - Private Methods
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = K.NavBar.backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = K.NavBar.backButtonImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = K.Colors.blackColor
    }
    
    // FIXME: - Request ???
    func makeOAuthTokenRequest(code: String) -> URLRequest {
        let urlString = AuthViewConstants.unsplashAuthorizeURLString
        
        guard var urlComponents = URLComponents(string: urlString) else {
            fatalError("Неверный URL")
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else { fatalError("Неверный URL") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print(request)
        return request
    }

}

extension AuthViewController: AuthViewDelegate {
    func pushToUIWebView() {
        let webViewController = WebViewViewController()
        webViewController.delegate = self
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    ) {
        //TODO: process code
        print("Код авторизации: \(code)")
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        print("Авторизация отменена")
        vc.dismiss(animated: true)
    }
}
