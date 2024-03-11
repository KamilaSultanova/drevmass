//
// TabBarController
// Created by Nurasyl on 22.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
}

// MARK: - Private extension

private extension TabBarController {
    func setupTabBar() {
        tabBar.unselectedItemTintColor = .appGray60
        tabBar.tintColor = .appDark90
        tabBar.backgroundColor = .appBeige10
    }

    func setupViewControllers() {
        let coursesVC = CoursesViewController()
        let catalogVC = CatalogViewController()
        let cartVC = CartViewController()
        let profileVC = ProfileViewController()

        coursesVC.tabBarItem = UITabBarItem(title: "Курсы", image: .TabBar.courses, tag: 1)
        catalogVC.tabBarItem = UITabBarItem(title: "Каталог", image: .TabBar.catalog, tag: 2)
        cartVC.tabBarItem = UITabBarItem(title: "Корзина", image: .TabBar.cart, tag: 3)
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: .TabBar.profile, tag: 4)

        let viewControllers = [coursesVC, catalogVC, cartVC, profileVC].map { vc in
            let navigationController = UINavigationController(rootViewController: vc)

            navigationController.navigationBar.prefersLargeTitles = true

            return navigationController
        }

        setViewControllers(viewControllers, animated: false)
    }
}
