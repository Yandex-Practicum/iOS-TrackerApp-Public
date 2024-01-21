//
//  ScheduleViewCell.swift
//  Tracker
//
//  Created by Никита Гончаров on 21.01.2024.
//

import UIKit

final class ScheduleViewCell: UITableViewCell {
    
    var selectedDay: Bool = false
    
    private let dayOfWeek: UILabel = {
        let dayOfWeek = UILabel()
        dayOfWeek.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        dayOfWeek.translatesAutoresizingMaskIntoConstraints = false
        return dayOfWeek
    }()
    
    private lazy var switchDay: UISwitch = {
        let switchDay = UISwitch()
        switchDay.onTintColor = UIColor.ypBlue
        switchDay.translatesAutoresizingMaskIntoConstraints = false
        switchDay.addTarget(self, action: #selector(switchTapped), for: .touchUpInside)
        return switchDay
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .ypBackgroundDay
        clipsToBounds = true
        
        contentView.addSubview(dayOfWeek)
        addSubview(switchDay)
        
        NSLayoutConstraint.activate([
            dayOfWeek.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dayOfWeek.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchDay.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchDay.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func switchTapped(_ sender: UISwitch) {
        self.selectedDay = sender.isOn
    }
    
    func update(with title: String) {
        dayOfWeek.text = title
    }
}
