//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 17.03.2025.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    // MARK: - Private Properties
    private let storage = OAuth2TokenStorage()
    
    // MARK: - UI
    private lazy var logoImageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "SplashScreen")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("spalsh screen")
        
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            switchToTabBarController()
        } else {
            showAuthViewController()
        }
    }
    
    // MARK: - Private Methods
    private func switchToTabBarController() {
        let tabBarController = UITabBarController()
        
        let imagesListVC = ImagesListViewController()
        imagesListVC.tabBarItem = UITabBarItem(title: nil, image: K.TapBarImages.editorialActive, tag: 0)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: nil, image: K.TapBarImages.profileActive, tag: 1)
        
        tabBarController.viewControllers = [imagesListVC, profileVC]
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = tabBarController
        }
    }
    
    private func showAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - Setup Views and Setup Constraints
private extension SplashScreenViewController {
    func setupViews() {
        view.backgroundColor = K.Colors.blackColor
        
        view.addSubview(logoImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}


extension SplashScreenViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true) {
            self.switchToTabBarController()
        }
    }
}
