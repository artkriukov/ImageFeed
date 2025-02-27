//
//  SingleImageView.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 27.02.2025.
//

import UIKit

protocol SingleImageViewDelegate: AnyObject {
    func didTapCloseButton()
}


final class SingleImageView: UIView {
    // MARK: - Private Properties
    weak var delegate: SingleImageViewDelegate?
    
    // MARK: - UI
    lazy var singleImage: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "0")
        element.contentMode = .scaleAspectFit
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var backwardButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(K.Images.backward, for: .normal)
        element.addTarget(self, action: #selector(backwardTapped), for: .touchUpInside)
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
    
    // MARK: - Private Methods
    
    @objc private func backwardTapped() {
        delegate?.didTapCloseButton()
    }

}

// MARK: - Setup Views and Setup Constraints
private extension SingleImageView {
    func setupViews() {
        backgroundColor = K.Colors.backgroundColor
        addSubview(singleImage)
        addSubview(backwardButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            singleImage.topAnchor.constraint(equalTo: topAnchor),
            singleImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            singleImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            singleImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            backwardButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 11),
            backwardButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 9),
            backwardButton.widthAnchor.constraint(equalToConstant: 24),
            backwardButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
