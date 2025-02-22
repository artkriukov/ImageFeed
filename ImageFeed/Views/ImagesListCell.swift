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
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "NoActiveBtn"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "TextColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        let likeImage = isLiked ? UIImage(named: "NoActiveBtn") : UIImage(named: "ActiveBtn")
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
