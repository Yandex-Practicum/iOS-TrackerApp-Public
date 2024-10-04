//
//  EmojiCell.swift
//  Tracker
//
//  Created by Sergey Ivanov on 30.09.2024.
//

import UIKit

final class EmojiCell: UICollectionViewCell {

    static let identifier = "EmojiCell"
    
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
        contentView.addSubview(emojiButton)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            emojiButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiButton.widthAnchor.constraint(equalToConstant: 52),
            emojiButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Конфигурация кнопки с эмодзи
    func configure(with emoji: String, isSelected: Bool) {
        emojiButton.setTitle(emoji, for: .normal)
        emojiButton.backgroundColor = isSelected ? UIColor.systemGray5 : UIColor.clear
    }

    // Позволяет добавить обработку нажатий извне
    func setButtonAction(target: Any?, action: Selector) {
        emojiButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
