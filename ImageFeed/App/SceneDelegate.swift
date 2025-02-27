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
        
        tapBarController.tabBar.tintColor = K.Colors.mainTextColor
        
        setupTabBarAppearance()
        
        window?.rootViewController = tapBarController
        window?.makeKeyAndVisible()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = K.Colors.backgroundColor
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

}

