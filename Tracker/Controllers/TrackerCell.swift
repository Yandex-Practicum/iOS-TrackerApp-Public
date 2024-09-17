import UIKit

class TrackerCell: UICollectionViewCell {
    static let identifier = "TrackerCell"
    
    // MARK: - UI Elements
    
    // Контейнер для всех элементов
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    // Фоновый вид для карточки трекера
    private let backgroundCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Эмодзи трекера
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Название трекера
    private let trackerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.baselineAdjustment = .alignBaselines
        return label
    }()
    
    // Кнопка действия (например, для отметки выполнения)
    let actionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white // Цвет иконки кнопки
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Счетчик выполнений (например, "0 дней")
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "0 дней"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Инициализация
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(backgroundCardView)
        backgroundCardView.addSubview(emojiLabel)
        backgroundCardView.addSubview(trackerNameLabel)
        
        containerView.addSubview(actionButton)
        containerView.addSubview(counterLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Настройка констрейнтов
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Контейнер
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 148),
            
            // Фоновый вид карточки
            backgroundCardView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundCardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundCardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundCardView.heightAnchor.constraint(equalToConstant: 90),
            
            // Эмодзи
            emojiLabel.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            // Название трекера
            trackerNameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            trackerNameLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -12),
            trackerNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: backgroundCardView.bottomAnchor, constant: -12),
            trackerNameLabel.heightAnchor.constraint(equalToConstant: 34),
            
            // Кнопка действия
            actionButton.topAnchor.constraint(equalTo: backgroundCardView.bottomAnchor, constant: 8),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            actionButton.widthAnchor.constraint(equalToConstant: 34),
            actionButton.heightAnchor.constraint(equalToConstant: 34),
            
            // Счетчик выполнений
            counterLabel.topAnchor.constraint(equalTo: backgroundCardView.bottomAnchor, constant: 16),
            counterLabel.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            counterLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 24)
        ])
    }
    
    // MARK: - Настройка ячейки
    
    func configure(with tracker: Tracker) {
        backgroundCardView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        trackerNameLabel.text = tracker.name
        actionButton.backgroundColor = tracker.color
        // Здесь можно обновить счетчик выполнений, если у вас есть такая информация
    }
}
