//
//  SceneDelegate.swift
//  drevmass
//
//  Created by Kamila Sultanova on 11.03.2024.
//

import UIKit
import KeychainSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
                
        if AuthService.shared.isAuthorized {
            let tabBarVC = TabBarController()
        
            window.rootViewController =  tabBarVC
        } else {
            let onboardingVC = OnboardingViewController()
            window.rootViewController = UINavigationController(rootViewController: onboardingVC)
           }
    
        self.window = window
        window.makeKeyAndVisible()
    }

}

