//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Sergey Ivanov on 09.09.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersImage = UIImage(systemName: "record.circle.fill") ?? UIImage()
        let statisticsImage = UIImage(systemName: "hare.fill") ?? UIImage()

        let trackersVC = TrackersViewController()
        let trackersNav = UINavigationController(rootViewController: trackersVC)
        trackersNav.tabBarItem = UITabBarItem(title: "Трекеры", image: trackersImage, tag: 0)

        let statisticsVC = UIViewController()  // Это будет экран статистики
        statisticsVC.view.backgroundColor = .white
        statisticsVC.tabBarItem = UITabBarItem(title: "Статистика", image: statisticsImage, tag: 1)

        viewControllers = [trackersNav, statisticsVC]
        
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBar.clipsToBounds = true
    }
}

@available(iOS 17, *)
#Preview {
    MainTabBarController()
}
