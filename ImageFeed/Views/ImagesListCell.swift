//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 20.02.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private lazy var mainImage: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "0")
        element.contentMode = .scaleAspectFill
        element.clipsToBounds = true
        element.layer.cornerRadius = 16
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var favoriteButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIImage(named: "NoActiveBtn"), for: .normal)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var dateLabel: UILabel = {
        let element = UILabel()
        element.text = "26 августа 2022"
        element.font = .systemFont(ofSize: 13)
        element.textColor = UIColor(named: "TextColor")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setViews()
        setupConstraints()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

private extension ImagesListCell {
    func setViews() {
        
        backgroundColor = .clear
        
        contentView.addSubview(mainImage)
        
        mainImage.addSubview(favoriteButton)
        mainImage.addSubview(dateLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainImage.heightAnchor.constraint(equalToConstant: 200),
            
            favoriteButton.topAnchor.constraint(equalTo: mainImage.topAnchor, constant: 13),
            favoriteButton.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: -13),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            dateLabel.bottomAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: mainImage.leadingAnchor, constant: 8),
        ])
    }
}
