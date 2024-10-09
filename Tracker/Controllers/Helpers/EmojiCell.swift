import UIKit

final class EmojiCell: UICollectionViewCell {

    static let identifier = "EmojiCell"
    
    // Добавляем замыкание для обработки нажатий на кнопку
    var didTapEmojiButton: (() -> Void)?

    private lazy var emojiButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Настройка UI

    private func setupView() {
        contentView.addSubview(emojiButton)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiButton.widthAnchor.constraint(equalToConstant: 52),
            emojiButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func setupActions() {
        emojiButton.addTarget(self, action: #selector(handleEmojiButtonTap), for: .touchUpInside)
    }

    // MARK: - Действия

    @objc private func handleEmojiButtonTap() {
        didTapEmojiButton?()  // Вызываем замыкание при нажатии
    }

    // Конфигурация кнопки с эмодзи
    func configure(with emoji: String, isSelected: Bool) {
        emojiButton.setTitle(emoji, for: .normal)
        emojiButton.backgroundColor = isSelected ? UIColor.systemGray5 : UIColor.clear
    }
}
