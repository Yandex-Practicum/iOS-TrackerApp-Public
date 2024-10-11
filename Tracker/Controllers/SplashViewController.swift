//
//  SplashViewController.swift
//  Tracker
//
//  Created by Sergey Ivanov on 09.09.2024.
//

import UIKit

final class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .launchScreenBackground

        let logoImageView = UIImageView()
        
        if let logoImage = UIImage(named: "logo") {
            logoImageView.image = logoImage
        } else {
            print("Ошибка: изображение 'logo' не найдено")
        }

//        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.goToMainScreen()
        }
    }

//    private func goToMainScreen() {
//        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
//           let window = sceneDelegate.window {
//            let tabBarController = MainTabBarController()
//            window.rootViewController = tabBarController
//            window.makeKeyAndVisible()
//        }
//    }
    private func goToMainScreen() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            print("Ошибка: не удалось получить SceneDelegate или window")
            return
        }

        let tabBarController = MainTabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

@available(iOS 17, *)
#Preview {
    SplashViewController()
}
