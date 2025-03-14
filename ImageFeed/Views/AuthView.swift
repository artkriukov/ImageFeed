//
//  AuthView.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 14.03.2025.
//

import UIKit

final class AuthView: UIView {

    // MARK: - UI
    private lazy var logoImageView: UIImageView = {
        let element = UIImageView()
        element.image = K.Images.unsplashLogo
        element.contentMode = .scaleAspectFit
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var logInButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Войти", for: .normal)
        element.tintColor = K.Colors.blackColor
        element.backgroundColor = .white
        element.layer.cornerRadius = 16
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set Views and Setup Constraints
private extension AuthView {
    func setupViews() {
        backgroundColor = K.Colors.blackColor
        
        addSubview(logoImageView)
        addSubview(logInButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
                logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                logoImageView.widthAnchor.constraint(equalToConstant: 60),
                
                logInButton.heightAnchor.constraint(equalToConstant: 48),
                logInButton.bottomAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.bottomAnchor,
                    constant: -90
                ),
                logInButton.leadingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.leadingAnchor,
                    constant: 16
                ),
                logInButton.trailingAnchor.constraint(
                        equalTo: safeAreaLayoutGuide.trailingAnchor,
                        constant: -16
                    ),
            ])
    }
}
