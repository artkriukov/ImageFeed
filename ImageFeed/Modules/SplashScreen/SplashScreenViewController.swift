//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 17.03.2025.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    
    // MARK: - Private Properties
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
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
            fetchProfileAndAvatar(token: token)
        } else {
            showAuthViewController()
        }
    }
    
    // MARK: - Private Methods
    private func switchToTabBarController() {
        let tabBarController = UITabBarController()
        
        let imagesListVC = ImagesListViewController()
        imagesListVC.tabBarItem = UITabBarItem(title: nil, image: UIConstants.TapBarImages.editorialActive, tag: 0)
        imagesListVC.tabBarItem.accessibilityIdentifier = "feed_tab_button"
        
        let profileVC = ProfileViewController()
        let presenter = ProfilePresenter()
        profileVC.presenter = presenter
        presenter.view = profileVC
        
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIConstants.TapBarImages.profileActive, tag: 1)
        profileVC.tabBarItem.accessibilityIdentifier = "profile_tab_button"
        
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
        view.backgroundColor = UIConstants.Colors.blackColor
        
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
        vc.dismiss(animated: true)
        
        guard let token = storage.token else { return }
        
        fetchProfileAndAvatar(token: token)
    }
    
    private func fetchProfileAndAvatar(token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                
                self.fetchProfileImage(username: profile.username)
                
                DispatchQueue.main.async {
                    self.switchToTabBarController()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchProfileImage(username: String) {
        
        profileImageService.fetchProfileImageURL(username: username) { _ in
        
        }
    }
}
