import UIKit

final class CreateHabitView: UIView {

    // MARK: - UI Elements

    lazy var trackerNameTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.layer.cornerRadius = 16
        textView.backgroundColor = .systemGray6
        textView.textContainerInset = UIEdgeInsets(top: 27, left: 12, bottom: 20, right: 40)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите название трекера"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    lazy var trackerNameContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var optionsContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var categoryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var selectedCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "" // Изначально пусто
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true // Скрыт по умолчанию
        return label
    }()

    private lazy var categoryChevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrow_right"))
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var scheduleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var scheduleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var selectedDaysLabel: UILabel = {
        let label = UILabel()
        label.text = "" // Изначально пусто
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true // Скрыт по умолчанию
        return label
    }()

    private lazy var scheduleChevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrow_right"))
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor(named: "cancelButton"), for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "cancelButton")?.cgColor
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "createButtonNone") // Изначально неактивна
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()

    // Констрейнты для динамических отступов
    private var categoryTitleLabelTopConstraint: NSLayoutConstraint!
    private var scheduleTitleLabelTopConstraint: NSLayoutConstraint!

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

        // Добавляем элементы для ввода названия трекера
        addSubview(trackerNameContainer)
        trackerNameContainer.addSubview(trackerNameTextView)
        trackerNameContainer.addSubview(placeholderLabel)
        trackerNameContainer.addSubview(clearButton)
        addSubview(errorLabel)

        // Настраиваем констрейнты для ввода названия трекера
        NSLayoutConstraint.activate([
            trackerNameContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerNameContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            trackerNameContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            trackerNameContainer.heightAnchor.constraint(equalToConstant: 75),

            trackerNameTextView.leadingAnchor.constraint(equalTo: trackerNameContainer.leadingAnchor),
            trackerNameTextView.trailingAnchor.constraint(equalTo: trackerNameContainer.trailingAnchor),
            trackerNameTextView.topAnchor.constraint(equalTo: trackerNameContainer.topAnchor),
            trackerNameTextView.bottomAnchor.constraint(equalTo: trackerNameContainer.bottomAnchor),

            placeholderLabel.leadingAnchor.constraint(equalTo: trackerNameTextView.leadingAnchor, constant: 16),
            placeholderLabel.centerYAnchor.constraint(equalTo: trackerNameTextView.centerYAnchor),

            clearButton.trailingAnchor.constraint(equalTo: trackerNameContainer.trailingAnchor, constant: -8),
            clearButton.centerYAnchor.constraint(equalTo: trackerNameContainer.centerYAnchor),

            errorLabel.topAnchor.constraint(equalTo: trackerNameContainer.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        // Добавляем контейнер для опций
        addSubview(optionsContainer)

        // Добавляем элементы категории
        optionsContainer.addSubview(categoryView)
        categoryView.addSubview(categoryLabel)
        categoryView.addSubview(selectedCategoryLabel)
        categoryView.addSubview(categoryChevronImageView)

        // Добавляем разделитель
        optionsContainer.addSubview(separatorLine)

        // Добавляем элементы расписания
        optionsContainer.addSubview(scheduleView)
        scheduleView.addSubview(scheduleTitleLabel)
        scheduleView.addSubview(selectedDaysLabel)
        scheduleView.addSubview(scheduleChevronImageView)

        // Настраиваем констрейнты для optionsContainer и его элементов
        NSLayoutConstraint.activate([
            optionsContainer.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 32),
            optionsContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            optionsContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            optionsContainer.heightAnchor.constraint(equalToConstant: 150),

            // Категория
            categoryView.topAnchor.constraint(equalTo: optionsContainer.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 75),

            // Разделитель
            separatorLine.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),

            // Расписание
            scheduleView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            scheduleView.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor),
            scheduleView.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor),
            scheduleView.bottomAnchor.constraint(equalTo: optionsContainer.bottomAnchor),
            scheduleView.heightAnchor.constraint(equalToConstant: 75),
        ])

        // Констрейнты для categoryLabel и selectedCategoryLabel
        categoryTitleLabelTopConstraint = categoryLabel.topAnchor.constraint(equalTo: categoryView.topAnchor, constant: 27)
        categoryTitleLabelTopConstraint.isActive = true

        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: categoryChevronImageView.leadingAnchor, constant: -8),

            selectedCategoryLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 2),
            selectedCategoryLabel.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 16),
            selectedCategoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: categoryChevronImageView.leadingAnchor, constant: -8),
            selectedCategoryLabel.bottomAnchor.constraint(lessThanOrEqualTo: categoryView.bottomAnchor, constant: -8),

            categoryChevronImageView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor, constant: -16),
            categoryChevronImageView.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            categoryChevronImageView.widthAnchor.constraint(equalToConstant: 24),
            categoryChevronImageView.heightAnchor.constraint(equalToConstant: 24),
        ])

        // Констрейнты для расписания
        scheduleTitleLabelTopConstraint = scheduleTitleLabel.topAnchor.constraint(equalTo: scheduleView.topAnchor, constant: 27)
        scheduleTitleLabelTopConstraint.isActive = true

        NSLayoutConstraint.activate([
            scheduleTitleLabel.leadingAnchor.constraint(equalTo: scheduleView.leadingAnchor, constant: 16),
            scheduleTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: scheduleChevronImageView.leadingAnchor, constant: -8),

            selectedDaysLabel.topAnchor.constraint(equalTo: scheduleTitleLabel.bottomAnchor, constant: 2),
            selectedDaysLabel.leadingAnchor.constraint(equalTo: scheduleView.leadingAnchor, constant: 16),
            selectedDaysLabel.trailingAnchor.constraint(lessThanOrEqualTo: scheduleChevronImageView.leadingAnchor, constant: -8),
            selectedDaysLabel.bottomAnchor.constraint(lessThanOrEqualTo: scheduleView.bottomAnchor, constant: -8),

            scheduleChevronImageView.trailingAnchor.constraint(equalTo: scheduleView.trailingAnchor, constant: -16),
            scheduleChevronImageView.centerYAnchor.constraint(equalTo: scheduleView.centerYAnchor),
            scheduleChevronImageView.widthAnchor.constraint(equalToConstant: 24),
            scheduleChevronImageView.heightAnchor.constraint(equalToConstant: 24),
        ])

        // Добавляем кнопки
        addSubview(cancelButton)
        addSubview(createButton)

        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -1),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),

            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -1),
            createButton.heightAnchor.constraint(equalToConstant: 60),

            // Ширина кнопок
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor)
        ])
    }

    // MARK: - Methods

    func updateSelectedDaysLabel(with text: String) {
        selectedDaysLabel.text = text
        let isScheduleSelected = !text.isEmpty

        selectedDaysLabel.isHidden = !isScheduleSelected

        // Обновляем верхний отступ для scheduleTitleLabel
        scheduleTitleLabelTopConstraint.constant = isScheduleSelected ? 15 : 27

        // Анимируем изменения
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.layoutIfNeeded()
        }
    }

    func updateSelectedCategoryLabel(with text: String) {
        selectedCategoryLabel.text = text
        let isCategorySelected = !text.isEmpty

        selectedCategoryLabel.isHidden = !isCategorySelected

        // Обновляем верхний отступ для categoryLabel
        categoryTitleLabelTopConstraint.constant = isCategorySelected ? 15 : 27

        // Анимируем изменения
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.layoutIfNeeded()
        }
    }
}
