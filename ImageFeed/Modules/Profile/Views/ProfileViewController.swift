//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 27.02.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Private Properties
    private let profileView = ProfileView()
    
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = profileView
        setupLogoutButton()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        profileView.addGradientAnimation()
    }
    
    private func setupLogoutButton() {
        profileView.logoutButton.addTarget(
            self,
            action: #selector(didTapLogoutButton),
            for: .touchUpInside
        )
    }
    
    @objc private func didTapLogoutButton() {
        ProfileLogoutService.shared.logout()
    }
    
    private func updateAvatar() {
        profileView.addGradientAnimation()
        
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else {
            
            return
        }
        
        self.profileView.userImage.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ],
            completionHandler: { [weak self] _ in
                self?.profileView.removeGradientAnimation()
            }
        )
    }
    
    
}
