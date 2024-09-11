//
//  CreateTrackerTypeView.swift
//  Tracker
//
//  Created by Sergey Ivanov on 09.09.2024.
//

import UIKit

class CreateTrackerTypeView: UIView {

    // MARK: - UI Elements
    
    let habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let eventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нерегулярные событие", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
        
        private func setupLayout() {
            backgroundColor = .white
            
            addSubview(habitButton)
            addSubview(eventButton)
            
            NSLayoutConstraint.activate([
                habitButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                habitButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                habitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                habitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                habitButton.heightAnchor.constraint(equalToConstant: 60),
                
                eventButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
                eventButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                eventButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                eventButton.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
}
