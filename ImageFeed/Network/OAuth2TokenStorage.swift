//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 16.03.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init () {}
    
    private let tokenKey = "BearerToken"
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                keychainWrapper.set(token, forKey: tokenKey)
            } else {
                keychainWrapper.removeObject(forKey: tokenKey)
            }
        }
    }
}
