//
//  CategoryFormViewController.swift
//  Tracker
//
//  Created by Sergey Ivanov on 12.10.2024.
//
import UIKit

final class CategoryFormViewController: UIViewController {

    var onCategorySaved: (() -> Void)?

    private let viewModel: CategoryFormViewModel
    private var existingCategory: TrackerCategory?

    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.backgroundColor = .tableBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        return textField
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = .createButtonNone
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()

    init(viewModel: CategoryFormViewModel, category: TrackerCategory? = nil) {
        self.viewModel = viewModel
        self.existingCategory = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupTapGesture()

        if let category = existingCategory {
            titleTextField.text = category.title
            viewModel.categoryTitle = category.title
            updateDoneButtonState()
        }
    }

    private func setupNavigationBar() {
        navigationItem.title = existingCategory == nil ? "Новая категория" : "Редактирование категории"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(titleTextField)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.categoryTitle = textField.text ?? ""
        updateDoneButtonState()
    }

    private func updateDoneButtonState() {
        let isTitleValid = !viewModel.categoryTitle.trimmingCharacters(in: .whitespaces).isEmpty
        doneButton.isEnabled = isTitleValid
        doneButton.backgroundColor = isTitleValid ? .createButtonActive : .createButtonNone
    }

    @objc private func doneButtonTapped() {
        if let existingCategory = existingCategory {
            viewModel.updateCategory(existingCategory)
        } else {
            viewModel.saveCategory()
        }
        onCategorySaved?()
        dismiss(animated: true, completion: nil)
    }
}
