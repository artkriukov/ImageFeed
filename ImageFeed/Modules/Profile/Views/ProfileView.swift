//
//  ProfileView.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 27.02.2025.
//

import UIKit

final class ProfileView: UIView {
    
    // MARK: - UI
    private lazy var userStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.distribution = .equalSpacing
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private(set) lazy var userImage: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "UserPhoto")
        element.contentMode = .scaleAspectFill
        element.clipsToBounds = true
        element.layer.cornerRadius = 35
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var logoutButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIConstants.Images.logoutButton, for: .normal)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 8
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private(set) lazy var nameLabel: UILabel = {
        let element = UILabel()
        element.text = "Екатерина Новикова"
        element.font = .systemFont(ofSize: 23, weight: .bold)
        element.textColor = UIConstants.Colors.mainTextColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private(set) lazy var contentUserLabel: UILabel = {
        let element = UILabel()
        element.text = "@ekaterina_nov"
        element.numberOfLines = 0
        element.font = .systemFont(ofSize: 13, weight: .regular)
        element.textColor = UIConstants.Colors.secondaryTextColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private(set) lazy var descrUserLabel: UILabel = {
        let element = UILabel()
        element.text = "Hello, world!"
        element.font = .systemFont(ofSize: 13, weight: .regular)
        element.textColor = UIConstants.Colors.mainTextColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        
        updateProfileDetails()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    private func updateProfileDetails() {
        if let profile = ProfileService.shared.profile {
            nameLabel.text = profile.name
            contentUserLabel.text = profile.loginName
            descrUserLabel.text = profile.bio ?? "Нет описания"
        }
    }
    
}

// MARK: - Set Views and Setup Constraints
private extension ProfileView {
    func setupViews() {
        backgroundColor = UIConstants.Colors.blackColor
        
        addSubview(userStackView)
        userStackView.addArrangedSubview(userImage)
        userStackView.addArrangedSubview(logoutButton)
        
        addSubview(userInfoStackView)
        userInfoStackView.addArrangedSubview(nameLabel)
        userInfoStackView.addArrangedSubview(contentUserLabel)
        userInfoStackView.addArrangedSubview(descrUserLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            userStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            userStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            userImage.widthAnchor.constraint(equalToConstant: 70),
            userImage.heightAnchor.constraint(equalToConstant: 70),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            
            userInfoStackView.topAnchor.constraint(equalTo: userStackView.bottomAnchor, constant: 8),
            userInfoStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userInfoStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
}
