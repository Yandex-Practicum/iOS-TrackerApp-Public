//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Sergey Ivanov on 09.09.2024.
//

import UIKit

class TrackersViewController: UIViewController {

    // MARK: - Properties
    
    private let trackersView = TrackersView()
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        view = trackersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(named: "pluse")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addButton.addTarget(self, action: #selector(addTracker), for: .touchUpInside)

        let addButtonContainer = UIView()
        addButtonContainer.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: addButtonContainer.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: addButtonContainer.trailingAnchor),
            addButton.topAnchor.constraint(equalTo: addButtonContainer.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: addButtonContainer.bottomAnchor)
        ])
        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.addSubview(addButtonContainer)
        addButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButtonContainer.leadingAnchor.constraint(equalTo: navigationBar!.leadingAnchor, constant: 6),
            addButtonContainer.centerYAnchor.constraint(equalTo: navigationBar!.centerYAnchor)
        ])
        
        let datePickerContainer = UIBarButtonItem(customView: trackersView.datePicker)
        trackersView.datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        navigationItem.rightBarButtonItem = datePickerContainer
    }

    private func setupActions() {
        trackersView.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - Actions
    
    @objc private func addTracker() {
        print("Add Tracker tapped")
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        print("Дата изменена на \(sender.date)")
    }
}
