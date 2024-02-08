//
//  TabBarController.swift
//  Tracker
//
//  Created by Никита Гончаров on 21.01.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Trackers"),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Stats"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackersViewController, statisticViewController]
        
        let separatorImage = UIImage()

        self.tabBar.shadowImage = separatorImage
        self.tabBar.backgroundImage = separatorImage
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.clipsToBounds = true
    }
}
