//
//  Constants.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 27.02.2025.
//

import UIKit

struct UIConstants {
    struct Colors {
        static let blackColor = UIColor(named: "BackgroundColor")
        static let secondaryTextColor = UIColor(named: "SecondaryText")
        static let mainTextColor = UIColor(named: "MainTextColor")
    }
    
    struct Images {
        static let logoutButton = UIImage(named: "Exit")
        static let noActiveButton = UIImage(named: "NoActiveBtn")
        static let activeButton = UIImage(named: "ActiveBtn")
        static let backward = UIImage(named: "Backward")
        static let sharingImage = UIImage(named: "Sharing")
        static let unsplashLogo = UIImage(named: "UnsplashLogo")
    }
    
    struct NavBar {
        static let backButtonImage = UIImage(named: "nav_back_button")
    }
    
    struct TapBarImages {
        static let editorialActive = UIImage(named: "tab_editorial_active")
        static let profileActive = UIImage(named: "tab_profile_active")
    }
    
}
