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
        
        tableView.delegate = self
        view.backgroundColor = UIConstants.Colors.blackColor
    }
}

extension ImagesListViewController: ImagesTableViewDelegate {
    func didSelectImage(_ image: UIImage) {
        let singleImageVC = SingleImageViewController()
        singleImageVC.singleImageView.singleImage.image = image
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true)
    }
}
