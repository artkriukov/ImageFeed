//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 07.05.2025.
//

import Foundation
import Kingfisher

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogout()
    func updateProfileDetails()
    func updateAvatar()
    func didTapConfirmLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let logoutService: ProfileLogoutServiceProtocol
    
    init(
        profileService: ProfileServiceProtocol = ProfileService.shared,
        profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
        logoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.logoutService = logoutService
    }
    
    func viewDidLoad() {
        updateProfileDetails()
        updateAvatar()
        setupObserver()
    }
    
    func didTapLogout() {
        view?.showLogoutConfirmationAlert()
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.setProfileDetails(
            name: profile.name,
            loginName: profile.loginName,
            bio: profile.bio
        )
    }
    
    func updateAvatar() {
        view?.showLoadingAnimation()
        
        guard let username = profileService.profile?.username else {
            view?.hideLoadingAnimation()
            return
        }
        
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.view?.hideLoadingAnimation()
                switch result {
                case .success(let urlString):
                    if let url = URL(string: urlString) {
                        self.view?.setAvatar(url: url)
                    }
                case .failure(let error):
                    print("Ошибка загрузки аватарки: \(error)")
                }
            }
        }
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
    
    func didTapConfirmLogout() {
        logoutService.logout()
    }
}
