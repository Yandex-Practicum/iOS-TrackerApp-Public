//
//  ViewController.swift
//  Tracker
//
//  Created by Sergey Ivanov on 04.09.2024.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let dateContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .dateLabelBackground)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "14.12.22" // Здесь нужно будет динамически подставить дату
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Контейнер для верхней части (заголовок, поиск)
    private let topContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Убираем разделительные линии сверху и снизу
        searchBar.backgroundImage = UIImage() // Полностью убираем фон и разделители
        
        return searchBar
    }()
    
    // Контейнер для заглушки
    private let placeholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tabBar: UITabBar = {
        let tabBar = UITabBar()
        let trackersTab = UITabBarItem(title: "Трекеры", image: UIImage(systemName: "record.circle.fill"), tag: 0)
        let statsTab = UITabBarItem(title: "Статистика", image: UIImage(systemName: "hare.fill"), tag: 1)
        tabBar.setItems([trackersTab, statsTab], animated: false)
        tabBar.selectedItem = trackersTab
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
    }
    
    // MARK: - Setup Navigation Bar
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }

        // Левый элемент: кнопка "+"
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(named: "pluse")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addButton.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        
        // Оборачиваем кнопку в кастомный `UIView`
        let addButtonContainer = UIView()
        addButtonContainer.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: addButtonContainer.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: addButtonContainer.trailingAnchor),
            addButton.topAnchor.constraint(equalTo: addButtonContainer.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: addButtonContainer.bottomAnchor)
        ])
        
        // Добавляем контейнер в `navigationBar`
        navigationBar.addSubview(addButtonContainer)
        addButtonContainer.translatesAutoresizingMaskIntoConstraints = false

        // Устанавливаем отступ 6pt слева
        NSLayoutConstraint.activate([
            addButtonContainer.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 6),
            addButtonContainer.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
        
        // Правый элемент: дата
        let dateContainerView = UIView()
        dateContainerView.backgroundColor = UIColor(resource: .dateLabelBackground)
        dateContainerView.layer.cornerRadius = 8
        dateContainerView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: dateContainerView.leadingAnchor, constant: 5.5),
            dateLabel.trailingAnchor.constraint(equalTo: dateContainerView.trailingAnchor, constant: -5.5),
            dateLabel.topAnchor.constraint(equalTo: dateContainerView.topAnchor, constant: 6),
            dateLabel.bottomAnchor.constraint(equalTo: dateContainerView.bottomAnchor, constant: -6)
        ])

        // Добавляем контейнер для даты в `navigationBar`
        navigationBar.addSubview(dateContainerView)
        dateContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Устанавливаем отступ 6pt справа
        NSLayoutConstraint.activate([
            dateContainerView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16),
            dateContainerView.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
    }

    // MARK: - Layout Setup
    
    private func setupLayout() {
        // Добавляем контейнер для заголовка и поиска
        view.addSubview(topContainerView)
        topContainerView.addSubview(titleLabel)
        topContainerView.addSubview(searchBar)
        
        // Добавляем контейнер для заглушки (картинка + текст)
        view.addSubview(placeholderView)
        placeholderView.addSubview(placeholderImageView)
        placeholderView.addSubview(placeholderLabel)
        
        // Добавляем Tab Bar
        view.addSubview(tabBar)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Top Container View
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 16),
            
            // Search Bar
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -16),
            topContainerView.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            
            // Placeholder View
            placeholderView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 220),
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Placeholder Image
            placeholderImageView.topAnchor.constraint(equalTo: placeholderView.topAnchor),
            placeholderImageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 64),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 64),
            
            // Placeholder Label
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            
            // Tab Bar
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addTracker() {
        print("Add Tracker tapped")
    }
}
