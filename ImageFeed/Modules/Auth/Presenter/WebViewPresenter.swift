//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 07.05.2025.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    private let progressThreshold: Float = 0.0001
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    func viewDidLoad() {
        loadAuthRequest()
        resetProgress()
    }

    private func loadAuthRequest() {
        guard let request = authHelper.authRequest() else { return }
        view?.load(request: request)
    }

    private func resetProgress() {
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        view?.setProgressHidden(shouldHideProgress(for: newProgressValue))
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= progressThreshold
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
