//
//  SceneDelegate.swift
//  drevmass
//
//  Created by Kamila Sultanova on 11.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        
        let rootVC = OnboardingViewController()
        window.rootViewController = UINavigationController(rootViewController: rootVC)
        
        self.window = window
        window.makeKeyAndVisible()
    }

}

