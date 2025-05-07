//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 07.05.2025.
//

import Foundation
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
