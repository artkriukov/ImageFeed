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
        OAuth2Service.shared.fetchOAuthToken(code: code) { result in
            switch result {
            case .success(let token):
                print("Токен успешно получен: \(token)")
                // Переход на следующий экран или обновление UI
            case .failure(let error):
                print("Ошибка при получении токена: \(error.localizedDescription)")
            }
        }
        print("Код авторизации: \(code)")
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        print("Авторизация отменена")
        vc.dismiss(animated: true)
    }
}
