//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 14.03.2025.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Private Properties
    private let authView = AuthView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = authView
        authView.delegate = self
    }

}

extension AuthViewController: AuthViewDelegate {
    func pushToUIWebView() {
        let webViewController = WebViewController()
        self.navigationController?.pushViewController(webViewController, animated: true)
        print(123)
    }
}
