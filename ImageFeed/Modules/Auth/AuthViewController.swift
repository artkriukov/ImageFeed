//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 14.03.2025.
//

import UIKit
import ProgressHUD

enum AuthViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/token"
}

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    // MARK: - Private Properties
    private let authView = AuthView()
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = authView
        authView.delegate = self
        
        configureBackButton()
    }
    
    // MARK: - Private Methods
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIConstants.NavBar.backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIConstants.NavBar.backButtonImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIConstants.Colors.blackColor
    }
}

extension AuthViewController: AuthViewDelegate {
    func pushToUIWebView() {
        let webViewController = WebViewViewController()
        webViewController.delegate = self
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    ) {
        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                print("Токен успешно получен: \(token)")
                DispatchQueue.main.async {
                    self.delegate?.didAuthenticate(self)
                }
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
