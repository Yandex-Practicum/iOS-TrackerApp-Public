//
//  CreateTrackerTypeViewController.swift
//  Tracker
//
//  Created by Sergey Ivanov on 09.09.2024.
//

import UIKit

class CreateTrackerTypeViewController: UIViewController {

    // MARK: - Properties
    
    private let createTrackerTypeView = CreateTrackerTypeView()
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        view = createTrackerTypeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Создание трекера"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
    }
    
    private func setupActions() {
        createTrackerTypeView.habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        createTrackerTypeView.eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func habitButtonTapped() {
        let createHabitVC = CreateHabitViewController()
        
        let navigationController = UINavigationController(rootViewController: createHabitVC)
        
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
//        createHabitVC.modalPresentationStyle = .pageSheet
//        present(createHabitVC, animated: true, completion: nil)
    }
    
    @objc private func eventButtonTapped() {
        print("Нерегулярное событие выбрано")
        // Здесь будет переход на экран добавления нерегулярного события
    }
}
