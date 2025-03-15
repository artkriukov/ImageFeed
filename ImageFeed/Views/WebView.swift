//
//  WebView.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 15.03.2025.
//

import UIKit
import WebKit

final class WebView: UIView {
    
    // MARK: - UI
    
    lazy var wkWebView: WKWebView = {
        let element = WKWebView()
        element.backgroundColor = .white
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
    
    // MARK: - Actions
    
}

// MARK: - Set Views and Setup Constraints
private extension WebView {
    func setupViews() {
        addSubview(wkWebView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            wkWebView.topAnchor.constraint(equalTo: topAnchor),
            wkWebView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: trailingAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
