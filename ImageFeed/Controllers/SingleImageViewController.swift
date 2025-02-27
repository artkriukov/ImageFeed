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
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = singleImageView
    }

}
