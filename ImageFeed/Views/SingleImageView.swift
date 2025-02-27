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
    private lazy var scrollView: UIScrollView = {
        let element = UIScrollView()
        element.delegate = self
        element.minimumZoomScale = 1.0
        element.maximumZoomScale = 3.0
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private(set) lazy var singleImage: UIImageView = {
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
        addSubview(scrollView)
        scrollView.addSubview(singleImage)
        addSubview(backwardButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            singleImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            singleImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            backwardButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 11),
            backwardButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 9),
            backwardButton.widthAnchor.constraint(equalToConstant: 24),
            backwardButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}

extension SingleImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImage
    }
}
