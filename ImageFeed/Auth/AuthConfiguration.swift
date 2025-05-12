//
//  Constants.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 13.03.2025.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    let tokenURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String,
         authURLString: String, tokenURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        self.tokenURLString = tokenURLString
    }

    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authURLString: Constants.unsplashAuthorizeURLString,
            tokenURLString: Constants.unsplashTokenURLString,
            defaultBaseURL: Constants.defaultBaseURL
        )
    }
}
