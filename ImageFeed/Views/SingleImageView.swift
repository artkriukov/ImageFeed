//
//  SingleImageView.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 27.02.2025.
//

import UIKit

final class SingleImageView: UIView {

    // MARK: - UI
    lazy var singleImage: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "0")
        element.contentMode = .scaleAspectFit
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

// MARK: - Setup Views and Setup Constraints
private extension SingleImageView {
    func setupViews() {
        backgroundColor = K.Colors.backgroundColor
        addSubview(singleImage)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            singleImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            singleImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            singleImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            singleImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
