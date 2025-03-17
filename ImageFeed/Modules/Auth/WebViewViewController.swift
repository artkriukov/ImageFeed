//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 14.03.2025.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

final class WebViewViewController: UIViewController {
    
    // MARK: - Private Properties
    private let webView = WebView()
    
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = webView
        webView.wkWebView.navigationDelegate = self
        
        loadAuthView()
        
        webView.wkWebView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
        
        updateProgress()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            delegate?.webViewViewControllerDidCancel(self)
        }
        
        webView.wkWebView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    // MARK: - Methods
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        webView.progressView.progress = Float(webView.wkWebView.estimatedProgress)
        webView.progressView.isHidden = fabs(webView.wkWebView.estimatedProgress - 1.0) <= 0.0001
    }
    
    // MARK: - Private Properties
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        webView.wkWebView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            //TODO: process code
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
