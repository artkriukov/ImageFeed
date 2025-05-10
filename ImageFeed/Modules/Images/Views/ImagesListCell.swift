//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 20.02.2025.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    private var currentPhotoId: String?
    private var animationLayers = Set<CALayer>()
    
    var onLikeButtonTapped: ((String) -> Void)?
    var isLiked = false
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - UI Elements
    let mainImage: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.clipsToBounds = true
        element.layer.cornerRadius = 16
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private let favoriteButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIConstants.Images.noActiveButton, for: .normal)
        element
            .addTarget(
                nil,
                action: #selector(likeButtonClicked),
                for: .touchUpInside
            )
        element.accessibilityIdentifier = "like_button"
        element.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private let dateLabel: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 13, weight: .regular)
        element.textColor = UIConstants.Colors.mainTextColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImage.kf.cancelDownloadTask()
        mainImage.image = nil
        removeGradientAnimation()
    }
    
    // MARK: - Configure Cell
    func configure(with photo: Photo, date: String) {
        currentPhotoId = photo.id
        dateLabel.text = date
        let likeImage = photo.isLiked ? UIConstants.Images.activeButton : UIConstants.Images.noActiveButton
        favoriteButton.setImage(likeImage, for: .normal)
        configureLikeButton(isLiked: photo.isLiked)
    }
    
    func configureLikeButton(isLiked: Bool) {
        let image = isLiked
            ? UIConstants.Images.activeButton
            : UIConstants.Images.noActiveButton
        favoriteButton.setImage(image, for: .normal)
        
        favoriteButton.accessibilityIdentifier = "like_button_\(isLiked ? "on" : "off")"
    }
    
    func showLoadingAnimation() {
        removeGradientAnimation()
        addGradientAnimation()
    }
    
    private func addGradientAnimation() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: mainImage.bounds.width, height: mainImage.bounds.height)
        
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 16
        gradient.masksToBounds = true
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.duration = 1.0
        animation.repeatCount = .infinity
        animation.fromValue = [0, 0.1, 0.3]
        animation.toValue = [0, 0.8, 1]
        
        gradient.add(animation, forKey: "locationsChange")
        mainImage.layer.addSublayer(gradient)
        animationLayers.insert(gradient)
    }
    
    func removeGradientAnimation() {
        animationLayers.forEach { $0.removeFromSuperlayer() }
        animationLayers.removeAll()
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(resource: .activeBtn) : UIImage(
            resource: .noActiveBtn
        )
        favoriteButton.imageView?.image = likeImage
        favoriteButton.setImage(likeImage, for: .normal)
    }
    
    @objc private func likeButtonClicked() {
        guard let photoId = currentPhotoId else { return }
        
        delegate?.imageListCellDidTapLike(self)
        onLikeButtonTapped?(photoId)
        print(1)
    }
}

// MARK: - Setup Views & Constraints
private extension ImagesListCell {
    func setupViews() {
        contentView.addSubview(mainImage)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(dateLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            favoriteButton.topAnchor.constraint(equalTo: mainImage.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor),
            
            dateLabel.bottomAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: mainImage.leadingAnchor, constant: 8),
        ])
    }
}
