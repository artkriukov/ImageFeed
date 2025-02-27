//
//  ImagesListViewController.swift.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 20.02.2025.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    private let tableView = ImagesTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = tableView
        view.backgroundColor = K.backgroundColor
    }
}

