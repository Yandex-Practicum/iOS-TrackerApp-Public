import UIKit

final class CreateEventViewController: UIViewController, UITextViewDelegate {

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось получить AppDelegate")
        }
        
        self.trackerStore = TrackerStore(context: appDelegate.persistentContainer.viewContext)
        self.categoryStore = TrackerCategoryStore(context: appDelegate.persistentContainer.viewContext)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onTrackerAdded: (() -> Void)?
    
    let createEventView = CreateEventView()
    
    private let trackerStore: TrackerStore
    private let categoryStore: TrackerCategoryStore
    
    private let maxNameLength = 38
    private var optionsTopConstraint: NSLayoutConstraint?
    private var selectedCategory: String?
    
    private var emoji: String = ""
    private var color: UIColor = UIColor(resource: .launchScreenBackground)

    // MARK: - View Lifecycle

    override func loadView() {
        view = createEventView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        setupTextViewDelegate()
        setupInitialConstraints()
        setupEmojiSelection()
        setupColorSelection()
        updateCreateButtonState()
    }

    // MARK: - Setup

    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Новое нерегулярное событие"
        
        guard let navigationBar = navigationController?.navigationBar else {
            print("NavigationController отсутствует")
            return
        }
        
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
    }

    private func setupActions() {
        createEventView.clearButton.addTarget(self, action: #selector(clearTextView), for: .touchUpInside)
        createEventView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createEventView.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        let categoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        createEventView.categoryView.addGestureRecognizer(categoryTapGesture)
    }

    private func setupTextViewDelegate() {
        createEventView.trackerNameTextView.delegate = self
    }

    private func setupInitialConstraints() {
        optionsTopConstraint = createEventView.optionsContainer.topAnchor.constraint(equalTo: createEventView.trackerNameContainer.bottomAnchor, constant: 24)
        optionsTopConstraint?.isActive = true
    }
    
    private func setupEmojiSelection() {
        createEventView.onEmojiSelected = { [weak self] selectedEmoji in
            self?.emoji = selectedEmoji
            self?.updateCreateButtonState()
            print("Выбранное эмодзи: \(selectedEmoji)")
        }
    }
    
    private func setupColorSelection() {
        createEventView.onColorSelected = { [weak self] selectedColor in
            self?.color = selectedColor
            self?.updateCreateButtonState()
            print("Выбранный цвет: \(selectedColor)")
        }
    }

    // MARK: - Actions

    @objc private func clearTextView() {
        createEventView.trackerNameTextView.text = ""
        createEventView.clearButton.isHidden = true
        createEventView.placeholderLabel.isHidden = false
        createEventView.errorLabel.isHidden = true
        updateOptionsContainerSpacing(hasError: false)
        updateCreateButtonState()
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func createButtonTapped() {
        print("Создание трекера")
        guard let trackerName = createEventView.trackerNameTextView.text, !trackerName.isEmpty else {
            print("Название трекера не заполнено!")
            return
        }

        guard let selectedCategory = selectedCategory else {
            print("Категория не выбрана!")
            return
        }

        guard let category = categoryStore.addCategory(title: selectedCategory) else {
            print("не получается создать категорию")
            return
        }

        guard let tracker = trackerStore.addTracker(name: trackerName, color: color, emoji: emoji, schedule: [], category: category) else {
            print("не получилось создать привычку")
            return
        }
        
        onTrackerAdded?()

        if let presentingVC = presentingViewController?.presentingViewController {
            presentingVC.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func categoryTapped() {
        let categoryStore = categoryStore
        let categoryViewModel = CategoryViewModel(categoryStore: categoryStore)
        let categoryViewController = CategoryViewController(viewModel: categoryViewModel, selectedCategory: selectedCategory)
        
        categoryViewController.onCategorySelected = { [weak self] selectedCategory in
            print("Выбранная категория в CreateEventViewController: \(selectedCategory)")
            self?.selectedCategory = selectedCategory
            self?.createEventView.updateSelectedCategoryLabel(with: selectedCategory)
            self?.updateCreateButtonState()
            self?.navigationController?.popViewController(animated: true)
        }
        
        navigationController?.pushViewController(categoryViewController, animated: true)
    }


    // MARK: - ScheduleViewControllerDelegate

    private func updateOptionsContainerSpacing(hasError: Bool) {
        optionsTopConstraint?.isActive = false

        if hasError {
            optionsTopConstraint = createEventView.optionsContainer.topAnchor.constraint(equalTo: createEventView.errorLabel.bottomAnchor, constant: 32)
        } else {
            optionsTopConstraint = createEventView.optionsContainer.topAnchor.constraint(equalTo: createEventView.trackerNameContainer.bottomAnchor, constant: 24)
        }

        optionsTopConstraint?.isActive = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - UITextViewDelegate

    func textViewDidChange(_ textView: UITextView) {
        let textCount = textView.text.count
        createEventView.clearButton.isHidden = textCount == 0
        createEventView.placeholderLabel.isHidden = textCount > 0

        if textCount >= maxNameLength {
            createEventView.errorLabel.isHidden = false
            updateOptionsContainerSpacing(hasError: true)
        } else {
            createEventView.errorLabel.isHidden = true
            updateOptionsContainerSpacing(hasError: false)
        }

        updateCreateButtonState()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newLength = currentText.count + text.count - range.length
        return newLength <= maxNameLength
    }

    // MARK: - Вспомогательные методы
    
    private func updateCreateButtonState() {
        print("Обновление состояния кнопки 'Создать'")
        let isNameEntered = !(createEventView.trackerNameTextView.text?.isEmpty ?? true)
        let isCategorySelected = selectedCategory != nil
        let isEmojiSelected = !emoji.isEmpty
        let isColorSelected = color != UIColor(resource: .launchScreenBackground)
        createEventView.createButton.isEnabled = isNameEntered && isCategorySelected && isEmojiSelected && isColorSelected
        print("Кнопка активна: \(createEventView.createButton.isEnabled)")
        createEventView.createButton.backgroundColor = createEventView.createButton.isEnabled ? UIColor(named: "createButtonActive") : UIColor(named: "createButtonNone")
    }
}

@available(iOS 17, *)
#Preview {
    CreateHabitViewController()
}

