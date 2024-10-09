import UIKit

final class ColorCell: UICollectionViewCell {

    static let identifier = "ColorCell"
    
    // Замыкание для обработки нажатий на кнопку
    var didTapColorButton: (() -> Void)?
    
    private let colorButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.clear.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        contentView.addSubview(borderView)
        borderView.addSubview(colorButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            borderView.widthAnchor.constraint(equalToConstant: 52),
            borderView.heightAnchor.constraint(equalToConstant: 52),
            borderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            colorButton.widthAnchor.constraint(equalToConstant: 40),
            colorButton.heightAnchor.constraint(equalToConstant: 40),
            colorButton.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            colorButton.centerYAnchor.constraint(equalTo: borderView.centerYAnchor)
        ])
    }

    private func setupActions() {
        colorButton.addTarget(self, action: #selector(handleColorButtonTap), for: .touchUpInside)
    }

    // MARK: - Действия

    @objc private func handleColorButtonTap() {
        didTapColorButton?()  // Вызываем замыкание при нажатии
    }

    // MARK: - Конфигурация

    func configure(with color: UIColor, isSelected: Bool) {
        colorButton.backgroundColor = color
        
        borderView.layer.borderWidth = isSelected ? 3 : 0
        borderView.layer.borderColor = isSelected ? color.withAlphaComponent(0.8).cgColor : UIColor.clear.cgColor
    }
}

