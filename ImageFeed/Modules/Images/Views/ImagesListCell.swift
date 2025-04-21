//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 20.02.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    // MARK: - UI Elements
    private let mainImage: UIImageView = {
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

    // MARK: - Configure Cell
    func configure(with photoName: String, isLiked: Bool, date: String) {
        mainImage.image = UIImage(named: photoName)
        dateLabel.text = date
        let likeImage = isLiked ? UIConstants.Images.noActiveButton : UIConstants.Images.activeButton
        self.selectionStyle = .none
        favoriteButton.setImage(likeImage, for: .normal)
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
