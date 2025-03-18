//
//  SingleImageView.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 27.02.2025.
//

import UIKit

protocol SingleImageViewDelegate: AnyObject {
    func didTapCloseButton()
    func didTapShareButton(image: UIImage)
}


final class SingleImageView: UIView {
    // MARK: - Private Properties
    weak var delegate: SingleImageViewDelegate?
    
    var image: UIImage? {
        didSet {
            singleImage.image = image
            if let image = image {
                rescaleAndCenterImageInScrollView(image: image)
            }
        }
    }
    
    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        let element = UIScrollView()
        element.delegate = self
        element.minimumZoomScale = 0.1
        element.maximumZoomScale = 1.3
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
        element.setImage(UIConstants.Images.backward, for: .normal)
        element.addTarget(self, action: #selector(backwardTapped), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var sharingButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIConstants.Images.sharingImage, for: .normal)
        element.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
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
    
    @objc private func shareTapped() {
        guard let image = singleImage.image else { return }
        delegate?.didTapShareButton(image: image)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

// MARK: - Setup Views and Setup Constraints
private extension SingleImageView {
    func setupViews() {
        backgroundColor = UIConstants.Colors.blackColor
        addSubview(scrollView)
        scrollView.addSubview(singleImage)
        addSubview(backwardButton)
        addSubview(sharingButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            singleImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            singleImage.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            singleImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            singleImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            backwardButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 11),
            backwardButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 9),
            backwardButton.widthAnchor.constraint(equalToConstant: 24),
            backwardButton.heightAnchor.constraint(equalToConstant: 24),
            
            sharingButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            sharingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -17),
        ])
    }
}

extension SingleImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImage
    }
}
