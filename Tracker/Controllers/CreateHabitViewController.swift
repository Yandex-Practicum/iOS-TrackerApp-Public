import UIKit

class CreateHabitViewController: UIViewController, UITextViewDelegate {

    // MARK: - Properties
    
    private let createHabitView = CreateHabitView()
    private let maxNameLength = 38
    private var optionsTopConstraint: NSLayoutConstraint?

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
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
    }
    
    private func setupActions() {
        createHabitView.clearButton.addTarget(self, action: #selector(clearTextView), for: .touchUpInside)
        createHabitView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createHabitView.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        // Добавляем скрытие клавиатуры по тапу
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupTextViewDelegate() {
        createHabitView.trackerNameTextView.delegate = self
    }
    
    private func setupInitialConstraints() {
        // Изначально отступы для контейнера опций
        optionsTopConstraint = createHabitView.optionsContainer.topAnchor.constraint(equalTo: createHabitView.trackerNameContainer.bottomAnchor, constant: 24)
        optionsTopConstraint?.isActive = true
    }
    
    // MARK: - Actions
    
    @objc private func clearTextView() {
        createHabitView.trackerNameTextView.text = ""
        createHabitView.clearButton.isHidden = true
        createHabitView.placeholderLabel.isHidden = false // Показать плейсхолдер
        createHabitView.errorLabel.isHidden = true
        updateOptionsContainerSpacing(hasError: false)
    }
        
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
        
    @objc private func createButtonTapped() {
        print("Создание трекера")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        let textCount = textView.text.count
        createHabitView.clearButton.isHidden = textCount == 0
        createHabitView.placeholderLabel.isHidden = textCount > 0 // Скрываем плейсхолдер при наличии текста

        if textCount >= maxNameLength {
            createHabitView.errorLabel.isHidden = false
            updateOptionsContainerSpacing(hasError: true)
        } else {
            createHabitView.errorLabel.isHidden = true
            updateOptionsContainerSpacing(hasError: false)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let newLength = currentText.count + text.count - range.length
        return newLength <= maxNameLength // Ограничиваем ввод до 38 символов
    }
    
    // Обновляем отступы при ошибке
    private func updateOptionsContainerSpacing(hasError: Bool) {
        optionsTopConstraint?.isActive = false

        if hasError {
            optionsTopConstraint = createHabitView.optionsContainer.topAnchor.constraint(equalTo: createHabitView.errorLabel.bottomAnchor, constant: 32)
        } else {
            optionsTopConstraint = createHabitView.optionsContainer.topAnchor.constraint(equalTo: createHabitView.trackerNameContainer.bottomAnchor, constant: 24)
        }
        
        optionsTopConstraint?.isActive = true

        // Принудительное обновление макета
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
