//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 27.02.2025.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    func setProfileDetails(name: String, loginName: String, bio: String?)
    func setAvatar(url: URL)
    func showLoadingAnimation()
    func hideLoadingAnimation()
    func showLogoutConfirmationAlert()
    func logout()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    private let profileView = ProfileView()
    var presenter: ProfilePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = profileView
        setupLogoutButton()
        presenter?.viewDidLoad()
    }
    
    private func setupLogoutButton() {
        profileView.logoutButton.addTarget(
            self,
            action: #selector(didTapLogoutButton),
            for: .touchUpInside
        )
    }
    
    @objc private func didTapLogoutButton() {
        presenter?.didTapLogout()
    }
    
    // MARK: - ProfileViewControllerProtocol
    func setProfileDetails(name: String, loginName: String, bio: String?) {
        profileView.nameLabel.text = name
        profileView.contentUserLabel.text = loginName
        profileView.descrUserLabel.text = bio ?? "Нет описания"
    }
    
    func setAvatar(url: URL) {
        profileView.userImage.kf.setImage(with: url)
    }
    
    func showLoadingAnimation() {
        profileView.addGradientAnimation()
    }
    
    func hideLoadingAnimation() {
        profileView.removeGradientAnimation()
    }
    
    func showLogoutConfirmationAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.view.accessibilityIdentifier = "logout_alert"
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        let yesAction = UIAlertAction(
                title: "Да",
                style: .destructive
            ) { [weak self] _ in
                self?.logout()
            }
        
            yesAction.accessibilityIdentifier = "logout_confirm_button" 
            alert.addAction(yesAction)
        present(alert, animated: true)
    }
    
    func logout() {
        presenter?.didTapConfirmLogout()
    }
}
