//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 30.04.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        resetAuthToken()
        resetServices()
        switchToAuthViewController()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func resetAuthToken() {
        OAuth2TokenStorage.shared.token = nil
    }
    
    private func resetServices() {
        ProfileService.shared.cleanProfile()
        ProfileImageService.shared.cleanAvatarURL()
        ImagesListService.shared.cleanPhotos()
    }
    
    private func switchToAuthViewController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            
            
            let authVC = AuthViewController()
            let navController = UINavigationController(rootViewController: authVC)
            window.rootViewController = navController
        }
    }
}
