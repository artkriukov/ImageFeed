//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 28.03.2025.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}
