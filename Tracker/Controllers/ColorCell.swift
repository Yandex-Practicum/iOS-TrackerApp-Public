//
//  ColorCell.swift
//  Tracker
//
//  Created by Sergey Ivanov on 01.10.2024.
//
import UIKit

final class ColorCell: UICollectionViewCell {

    static let identifier = "ColorCell"
    
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
        
        contentView.addSubview(borderView)
        borderView.addSubview(colorButton)

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with color: UIColor, isSelected: Bool) {
        colorButton.backgroundColor = color
        
        if isSelected {
            let borderColor = color.withAlphaComponent(0.8)
            borderView.layer.borderWidth = 3
            borderView.layer.borderColor = borderColor.cgColor
        } else {
            borderView.layer.borderWidth = 0
            borderView.layer.borderColor = UIColor.clear.cgColor
        }
    }

    func setButtonAction(target: Any?, action: Selector) {
        colorButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
