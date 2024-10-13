//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Sergey Ivanov on 13.10.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private lazy var pages: [UIViewController] = [
        OnboardingPageViewController(titleText: "Отслеживайте только\nто, что хотите", imageName: "page1"),
        OnboardingPageViewController(titleText: "Даже если это\nне литры воды и йога", imageName: "page2"),
    ]

    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = pages.count
        control.currentPage = 0
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .black
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .createButtonActive
        button.layer.cornerRadius = 16
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(skipOnboarding), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self

        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }

        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(pageControl)
        view.addSubview(skipButton)

        NSLayoutConstraint.activate([
            // PageControl
            pageControl.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Skip Button
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - DataSource Methods

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else { return nil }
        return pages[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < pages.count - 1 else { return nil }
        return pages[currentIndex + 1]
    }

    // MARK: - Delegate Method

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = viewControllers?.first, let index = pages.firstIndex(of: visibleViewController) {
            pageControl.currentPage = index
        }
    }

    // MARK: - Skip Button Action

    @objc private func skipOnboarding() {
        let mainVC = TrackersViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)

        // Сохраняем, что онбординг был завершен
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
    }
}

@available(iOS 17, *)
#Preview {
    OnboardingViewController()
}
