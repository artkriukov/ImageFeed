//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by Artem Kriukov on 20.02.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        let tapBarController = UITabBarController()
        
        let imagesListVC = ImagesListViewController()
        imagesListVC.tabBarItem = UITabBarItem(title: nil, image: K.TapBarImages.editorialActive, tag: 0)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: nil, image: K.TapBarImages.profileActive, tag: 1)
        
        tapBarController.viewControllers = [imagesListVC, profileVC]
        
        setupTabBarAppearance()
        
        window?.rootViewController = AuthViewController()
        window?.makeKeyAndVisible()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = K.Colors.blackColor
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        UITabBar.appearance().tintColor = K.Colors.mainTextColor
    }

}

