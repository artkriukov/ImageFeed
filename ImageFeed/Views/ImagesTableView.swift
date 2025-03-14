//
//  ImagesTableView.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 20.02.2025.
//

import UIKit

protocol ImagesTableViewDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
}

final class ImagesTableView: UIView {
    // MARK: - Private Properties
    private var photosName = Array(0..<20).map { "\($0)" }
    weak var delegate: ImagesTableViewDelegate?

    // MARK: - UI
    private lazy var imagesTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        element.dataSource = self
        element.delegate = self
        element.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        element.backgroundColor = K.Colors.blackColor
        element.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
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
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

// MARK: - UITableViewDataSource
extension ImagesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let photoName = photosName[indexPath.row]
        let isLiked = indexPath.row % 2 == 0
        let date = Self.dateFormatter.string(from: Date())
        
        cell.configure(with: photoName, isLiked: isLiked, date: date)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ImagesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / image.size.width
        return image.size.height * scale + imageInsets.top + imageInsets.bottom
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageName = photosName[indexPath.row]
        
        if let selectedImage = UIImage(named: imageName) ?? UIImage(named: "0") {
            delegate?.didSelectImage(selectedImage)
        }
    }
    
}

// MARK: - Set Views and Setup Constraints
private extension ImagesTableView {
    func setupViews() {
        addSubview(imagesTableView)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imagesTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imagesTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            imagesTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
