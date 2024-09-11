import UIKit

class CreateHabitView: UIView {
    
    // MARK: - UI Elements
    
    let trackerNameTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.layer.cornerRadius = 16
        textView.backgroundColor = .systemGray6
        textView.textContainerInset = UIEdgeInsets(top: 27, left: 12, bottom: 20, right: 40)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите название трекера"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trackerNameContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    let categoryView: UIStackView = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let scheduleView: UIStackView = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let optionsContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor(hex: "#F56B6C"), for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#F56B6C").cgColor
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(hex: "#AEAFB4")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .white
        
        addSubview(trackerNameContainer)
        trackerNameContainer.addSubview(trackerNameTextView)
        trackerNameContainer.addSubview(placeholderLabel)
        trackerNameContainer.addSubview(clearButton)
        addSubview(errorLabel)
        addSubview(optionsContainer)
        optionsContainer.addSubview(categoryView)
        optionsContainer.addSubview(separatorLine)
        optionsContainer.addSubview(scheduleView)
        addSubview(cancelButton)
        addSubview(createButton)
        
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
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Контейнер для кнопок Категория и Расписание
            optionsContainer.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 32),
            optionsContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            optionsContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            optionsContainer.heightAnchor.constraint(equalToConstant: 150),
                  
            categoryView.topAnchor.constraint(equalTo: optionsContainer.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor, constant: 16),
            categoryView.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor, constant: -16),
            categoryView.heightAnchor.constraint(equalToConstant: 75),
            
            // Разделительная линия
            separatorLine.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            // Расписание
            scheduleView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            scheduleView.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor, constant: 16),
            scheduleView.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor, constant: -16),
            scheduleView.heightAnchor.constraint(equalToConstant: 75),
            
            // Отмена
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -1),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),

            // Создать
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -1),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Ширина кнопок и равное распределение
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor)
        ])
    }
}

// Используем расширение для работы с hex-кодами
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
