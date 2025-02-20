//
//  ImagesTableView.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 20.02.2025.
//

import UIKit

final class ImagesTableView: UIView {

    private lazy var imagesTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        element.dataSource = self
        element.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        element.backgroundColor = UIColor(named: "BackgroundColor")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    init() {
        super.init(frame: .zero)
        setViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configCell(for cell: ImagesListCell) { } 

}
// MARK: - UITableViewDataSource
extension ImagesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as! ImagesListCell
        
        // configCell(for: imageListCell)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
 extension ImagesTableView: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
     }
}

// MARK: - Set Views and Setup Constraints
private extension ImagesTableView {
    func setViews() {
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
