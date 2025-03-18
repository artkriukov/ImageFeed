//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 27.02.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Private Properties
    let singleImageView = SingleImageView()
    private var image: UIImage?
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.delegate = self
        self.view = singleImageView
        
        if let image = image {
            singleImageView.image = image
        }
    }
}

extension SingleImageViewController: SingleImageViewDelegate {
    func didTapShareButton(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    func didTapCloseButton() {
        self.dismiss(animated: true)
    }
}
