//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Никита Гончаров on 26.01.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - UI-Elements
    private var header: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        label.backgroundColor = .ypWhiteDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyCategoryLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Empty trackers")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyCategoryText: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\n объединять по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .ypBlackDay
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlackDay
        button.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCategoryView()
        setupCategoryViewConstrains()
    }
    // MARK: - Actions
    @objc
    private func didTapAddCategoryButton() {
        // TODO: - Добавить переход на содание категории
    }
    
    // MARK: - Setup View
    private func setupCategoryView() {
        view.backgroundColor = .ypWhiteDay
        view.addSubview(header)
        view.addSubview(emptyCategoryLogo)
        view.addSubview(emptyCategoryText)
        view.addSubview(addCategoryButton)
    }
    
    private func setupCategoryViewConstrains() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyCategoryLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCategoryLogo.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyCategoryLogo.heightAnchor.constraint(equalToConstant: 80),
            emptyCategoryLogo.widthAnchor.constraint(equalToConstant: 80),
            
            emptyCategoryText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCategoryText.topAnchor.constraint(equalTo: emptyCategoryText.bottomAnchor, constant: 8),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
