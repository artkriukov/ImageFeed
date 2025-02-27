//
//  ImagesListViewController.swift.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 20.02.2025.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - Private Properties
    private let tableView = ImagesTableView()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = tableView
        
        tableView.selectionDelegate = self
        view.backgroundColor = K.Colors.backgroundColor
    }
}

extension ImagesListViewController: ImagesTableViewDelegate {
    func didSelectImage(_ image: UIImage) {
        let singleImageVC = SingleImageViewController()
        singleImageVC.singleImageView.singleImage.image = image
        navigationController?.pushViewController(singleImageVC, animated: true)
    }
}
