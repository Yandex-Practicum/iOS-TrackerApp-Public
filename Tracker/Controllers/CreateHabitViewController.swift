import UIKit

class CreateHabitViewController: UIViewController, UITextViewDelegate, ScheduleViewControllerDelegate {

    private var selectedDays: [DayOfWeek] = []
    private let createHabitView = CreateHabitView()
    private let maxNameLength = 38
    private var optionsTopConstraint: NSLayoutConstraint?
    private var selectedCategory: String?
    
    private var emoji: String = "😊"
    private var color: UIColor = UIColor(resource: .launchScreenBackground)

    // MARK: - View Lifecycle

    override func loadView() {
        view = createHabitView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        setupTextViewDelegate()
        setupInitialConstraints()

        createHabitView.updateSelectedDaysLabel(with: "")
        updateCreateButtonState()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
    }

    private func setupActions() {
        createHabitView.clearButton.addTarget(self, action: #selector(clearTextView), for: .touchUpInside)
        createHabitView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createHabitView.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        let categoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        createHabitView.categoryView.addGestureRecognizer(categoryTapGesture)

        let scheduleTapGesture = UITapGestureRecognizer(target: self, action: #selector(scheduleTapped))
        createHabitView.scheduleView.addGestureRecognizer(scheduleTapGesture)
    }

    private func setupTextViewDelegate() {
        createHabitView.trackerNameTextView.delegate = self
    }

    private func setupInitialConstraints() {
        optionsTopConstraint = createHabitView.optionsContainer.topAnchor.constraint(equalTo: createHabitView.trackerNameContainer.bottomAnchor, constant: 24)
        optionsTopConstraint?.isActive = true
    }

    // MARK: - Actions

    @objc private func clearTextView() {
        createHabitView.trackerNameTextView.text = ""
        createHabitView.clearButton.isHidden = true
        createHabitView.placeholderLabel.isHidden = false
        createHabitView.errorLabel.isHidden = true
        updateOptionsContainerSpacing(hasError: false)
        updateCreateButtonState()
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func createButtonTapped() {
        print("Создание трекера")
        guard let trackerName = createHabitView.trackerNameTextView.text, !trackerName.isEmpty else {
            print("Название трекера не заполнено!")
            return
        }

        guard let selectedCategory = selectedCategory else {
            print("Категория не выбрана!")
            return
        }

        let selectedDaysStrings = selectedDays.map { $0.rawValue }
        
        guard let category = CoreDataManager.shared.addCategory(title: selectedCategory) else {
            print("не получается создать категорию")
            return
        }
        
        guard let tracker = CoreDataManager.shared.addTracker(name: trackerName, color: color, emoji: emoji, schedule: selectedDaysStrings, category: category) else {
            print("не получилось создать привычку")
            return
        }
        
        print("\(CoreDataManager.shared.fetchTrackers())")
        dismiss(animated: true, completion: nil)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func scheduleTapped() {
        view.endEditing(true)
        let scheduleVC = ScheduleViewController(selectedDays: selectedDays)
        scheduleVC.delegate = self
        let navController = UINavigationController(rootViewController: scheduleVC)
        present(navController, animated: true, completion: nil)
    }

    @objc private func categoryTapped() {
        if selectedCategory == "Важное" {
            // Если категория уже выбрана, снимаем выбор
            selectedCategory = nil
            createHabitView.updateSelectedCategoryLabel(with: "")
        } else {
            // Если категория не выбрана, выбираем ее
            selectedCategory = "Важное"
            createHabitView.updateSelectedCategoryLabel(with: selectedCategory!)
        }
        updateCreateButtonState()
    }

    // MARK: - ScheduleViewControllerDelegate
    
    func didSelectDays(_ days: [String]) {
        print("didSelectDays called with days: \(days)")
        if days.count == DayOfWeek.allCases.count {
            createHabitView.updateSelectedDaysLabel(with: "Каждый день")
        } else {
            createHabitView.updateSelectedDaysLabel(with: days.joined(separator: ", "))
        }
        // Преобразуем строки обратно в DayOfWeek и сохраняем выбранные дни
        selectedDays = days.compactMap { DayOfWeek(rawValue: $0) }
    }

    private func updateOptionsContainerSpacing(hasError: Bool) {
        optionsTopConstraint?.isActive = false

        if hasError {
            optionsTopConstraint = createHabitView.optionsContainer.topAnchor.constraint(equalTo: createHabitView.errorLabel.bottomAnchor, constant: 32)
        } else {
            optionsTopConstraint = createHabitView.optionsContainer.topAnchor.constraint(equalTo: createHabitView.trackerNameContainer.bottomAnchor, constant: 24)
        }

        optionsTopConstraint?.isActive = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - UITextViewDelegate

    func textViewDidChange(_ textView: UITextView) {
        let textCount = textView.text.count
        createHabitView.clearButton.isHidden = textCount == 0
        createHabitView.placeholderLabel.isHidden = textCount > 0

        if textCount >= maxNameLength {
            createHabitView.errorLabel.isHidden = false
            updateOptionsContainerSpacing(hasError: true)
        } else {
            createHabitView.errorLabel.isHidden = true
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
        let isNameEntered = !(createHabitView.trackerNameTextView.text?.isEmpty ?? true)
        let isCategorySelected = selectedCategory != nil
        let isSelectedDays = selectedDays.count >= 1
        createHabitView.createButton.isEnabled = isNameEntered && isCategorySelected && isSelectedDays
        createHabitView.createButton.backgroundColor = createHabitView.createButton.isEnabled ? UIColor(named: "createButtonActive") : UIColor(named: "createButtonNone")
    }
}

@available(iOS 17, *)
#Preview {
    CreateHabitViewController()
}
