//
//  AuthConstants.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 12.05.2025.
//

import Foundation

enum Constants {
    static let accessKey = "GeT7ThY4qvWKbEBaDjmNDQXekNlC7obejNjlojaQhY8"
    static let secretKey = "Qt4BJXNksWzCJxc9sMw1wAyhfxuPvUHWE0I8zjN1Txk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
}
