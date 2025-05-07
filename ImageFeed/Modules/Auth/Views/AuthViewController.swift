//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 14.03.2025.
//

import UIKit

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
    
    private func showAuthErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: "ОK",
            style: .default
        )
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}

extension AuthViewController: AuthViewDelegate {
    func pushToUIWebView() {
        let webViewController = WebViewViewController()
        let authHelper = AuthHelper()

        let presenter = WebViewPresenter(authHelper: authHelper)
        
        webViewController.presenter = presenter
        presenter.view = webViewController
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
                
                DispatchQueue.main.async {
                    self.showAuthErrorAlert()
                }
            }
        }
        print("Код авторизации: \(code)")
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        print("Авторизация отменена")
        vc.dismiss(animated: true)
    }
}
