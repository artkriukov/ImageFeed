//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 27.02.2025.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Private Properties
    private let profileView = ProfileView()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = profileView
        
    }

}
