import UIKit

final class CreateEventView: UIView {

    var onEmojiSelected: ((String) -> Void)?
    private var selectedEmoji: String?
    private var selectedEmojiIndex: IndexPath?
    
    var onColorSelected: ((UIColor) -> Void)?
    private var selectedColorIndex: IndexPath?

    // MARK: - UI Elements

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private lazy var categoryChevronImageView: UIImageView = {
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
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 52, height: 52)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = false
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        return collectionView
    }()
    
    // Заголовок для секции с выбором цвета
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    // UICollectionView для выбора цветов
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 52, height: 52)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = false
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        return collectionView
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

        // Добавляем элемент scrollView
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor) // Высота контента должна быть больше или равна высоте scrollView
        ])
        
        // Добавляем элементы для ввода названия трекера
        contentView.addSubview(trackerNameContainer)
        trackerNameContainer.addSubview(trackerNameTextView)
        trackerNameContainer.addSubview(placeholderLabel)
        trackerNameContainer.addSubview(clearButton)
        
        // Добавляем элемент ошибки
        contentView.addSubview(errorLabel)

        // Настраиваем констрейнты для ввода названия трекера
        NSLayoutConstraint.activate([
            trackerNameContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            trackerNameContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerNameContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
            errorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        // Добавляем контейнер для опций
        contentView.addSubview(optionsContainer)

        // Добавляем элементы категории
        optionsContainer.addSubview(categoryView)
        categoryView.addSubview(categoryLabel)
        categoryView.addSubview(selectedCategoryLabel)
        categoryView.addSubview(categoryChevronImageView)

        // Настраиваем констрейнты для optionsContainer и его элементов
        NSLayoutConstraint.activate([
            optionsContainer.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 32),
            optionsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            optionsContainer.heightAnchor.constraint(equalToConstant: 75),

            // Категория
            categoryView.topAnchor.constraint(equalTo: optionsContainer.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 75),
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
        
        // Adding emoji section
        contentView.addSubview(emojiLabel)
        contentView.addSubview(emojiCollectionView)

        // Setup emoji collection view constraints
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: optionsContainer.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204)
        ])
        
        // Добавляем заголовок и коллекцию для выбора цвета
        contentView.addSubview(colorLabel)
        contentView.addSubview(colorCollectionView)

        // Setup color label and collection view constraints
        NSLayoutConstraint.activate([
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),

            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204)
        ])
        
        // Добавляем кнопки
        contentView.addSubview(cancelButton)
        contentView.addSubview(createButton)

        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            cancelButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),

            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            createButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            createButton.heightAnchor.constraint(equalToConstant: 60),

            // Ширина кнопок
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor)
        ])
    }
    
    // MARK: - Methods

    func updateSelectedCategoryLabel(with text: String) {
        selectedCategoryLabel.text = text
        let isCategorySelected = !text.isEmpty

        selectedCategoryLabel.isHidden = !isCategorySelected

        categoryTitleLabelTopConstraint.constant = isCategorySelected ? 15 : 27

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.layoutIfNeeded()
        }
    }
}

extension CreateEventView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Набор эмодзи
    private var emojis: [String] {
        ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
         "😇", "😡", "🥶", "🤔", "🙌", "🍔",
         "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    }
    
    // Набор цветов
    private var colors: [UIColor] {
        [UIColor(resource: .red), UIColor(resource: .orange), UIColor(resource: .blue), UIColor(resource: .purple), UIColor(resource: .green), UIColor(resource: .pink),
         UIColor(resource: .pinkLight), UIColor(resource: .blueLight), UIColor(resource: .greenLight), UIColor(resource: .indigoDark), UIColor(resource: .orangeHight), UIColor(resource: .pinkMedium),
         UIColor(resource: .brownLight), UIColor(resource: .purpleVeryLight), UIColor(resource: .purpleHight), UIColor(resource: .purpleMedium), UIColor(resource: .purpleLight), UIColor(resource: .greenHight)]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojis.count
        } else if collectionView == colorCollectionView {
            return colors.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as! EmojiCell
            let emoji = emojis[indexPath.item]
            let isSelected = indexPath == selectedEmojiIndex
            cell.configure(with: emoji, isSelected: isSelected)
            
            // Используем замыкание для обработки нажатия
            cell.didTapEmojiButton = { [weak self] in
                self?.emojiButtonTapped(at: indexPath)
            }
            return cell
        } else if collectionView == colorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
            let color = colors[indexPath.item]
            let isSelected = indexPath == selectedColorIndex
            cell.configure(with: color, isSelected: isSelected)
            
            // Используем замыкание для обработки нажатия
            cell.didTapColorButton = { [weak self] in
                self?.colorButtonTapped(at: indexPath)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    private func emojiButtonTapped(at indexPath: IndexPath) {
        //guard let emoji = emojis[safe: indexPath.item] else { return }
        let emoji = emojis[indexPath.item]

        // Проверяем, что выбран новый эмоджи
        if indexPath != selectedEmojiIndex {
            if let oldIndexPath = selectedEmojiIndex {
                selectedEmojiIndex = indexPath
                selectedEmoji = emoji

                // Перезагружаем только предыдущую и новую выбранную ячейки
                emojiCollectionView.reloadItems(at: [oldIndexPath, indexPath])
            } else {
                selectedEmojiIndex = indexPath
                selectedEmoji = emoji
                emojiCollectionView.reloadItems(at: [indexPath])
            }

            // Передаем выбранное эмодзи через коллбэк
            onEmojiSelected?(emoji)
        }
    }
    
    private func colorButtonTapped(at indexPath: IndexPath) {
        let selectedColor = colors[indexPath.item]

        if indexPath != selectedColorIndex {
            if let oldIndexPath = selectedColorIndex {
                selectedColorIndex = indexPath
                colorCollectionView.reloadItems(at: [oldIndexPath, indexPath])
            } else {
                selectedColorIndex = indexPath
                colorCollectionView.reloadItems(at: [indexPath])
            }

            // Передаем выбранный цвет через коллбэк
            onColorSelected?(selectedColor)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52) // Фиксированный размер ячеек
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Рассчитываем отступы, чтобы уместилось ровно 6 элементов в строке
        let totalCellWidth: CGFloat = 52 * 6 // Ширина всех ячеек в строке
        let totalSpacingWidth: CGFloat = 5 * 5 // Ширина всех промежутков между ячейками (5 промежутков по 5pt)
        let totalWidth = totalCellWidth + totalSpacingWidth
        let contentWidth = collectionView.bounds.width
        let horizontalInset: CGFloat = (contentWidth - totalWidth) / 2 // Центрируем ячейки в строке

        return UIEdgeInsets(top: 24, left: horizontalInset, bottom: 0, right: horizontalInset)
    }
}
