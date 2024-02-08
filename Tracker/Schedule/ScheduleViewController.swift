//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Никита Гончаров on 21.01.2024.
//

import UIKit

protocol SelectedDays {
    func save(indicies: [Int])
}

final class ScheduleViewController: UIViewController {
    
    let scheduleCellReuseIdentifier = "ScheduleTableViewCell"
    var createTrackerViewController: SelectedDays?
    
    private let header: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "Расписание"
        header.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        header.textColor = .ypBlackDay
        return header
    }()
    
    private let scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var doneScheduleButton: UIButton = {
        let doneScheduleButton = UIButton(type: .custom)
        doneScheduleButton.setTitleColor(.ypWhiteDay, for: .normal)
        doneScheduleButton.backgroundColor = .ypBlackDay
        doneScheduleButton.layer.cornerRadius = 16
        doneScheduleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneScheduleButton.setTitle("Готово", for: .normal)
        doneScheduleButton.addTarget(self, action: #selector(doneScheduleButtonTapped), for: .touchUpInside)
        doneScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        return doneScheduleButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        addSubviews()
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleTableView.register(ScheduleViewCell.self, forCellReuseIdentifier: scheduleCellReuseIdentifier)
        scheduleTableView.layer.cornerRadius = 16
        scheduleTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.topAnchor),
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scheduleTableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 524),
            doneScheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneScheduleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneScheduleButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(header)
        view.addSubview(scheduleTableView)
        view.addSubview(doneScheduleButton)
    }
    
    @objc private func doneScheduleButtonTapped() {
        var selected: [Int] = []
        for (index, elem) in scheduleTableView.visibleCells.enumerated() {
            guard let cell = elem as? ScheduleViewCell else {
                return
            }
            if cell.selectedDay {
                selected.append(index)
            }
        }
        self.createTrackerViewController?.save(indicies: selected)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let separatorInset: CGFloat = 16
        let separatorWidth = tableView.bounds.width - separatorInset * 2
        let separatorHeight: CGFloat = 1.0
        let separatorX = separatorInset
        let separatorY = cell.frame.height - separatorHeight
        
        let separatorView = UIView(frame: CGRect(x: separatorX, y: separatorY, width: separatorWidth, height: separatorHeight))
        separatorView.backgroundColor = .ypGray
        
        cell.addSubview(separatorView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleTableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: scheduleCellReuseIdentifier, for: indexPath) as? ScheduleViewCell else { return UITableViewCell() }
        
        let dayOfWeek = WeekDay.allCases[indexPath.row]
        cell.update(with: "\(dayOfWeek.name)")
        
        return cell
    }
}

enum WeekDay: Int, CaseIterable, Codable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    var name: String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
var shortDaysName: String {
    switch self {
    case .monday:
        return "Пн"
    case .tuesday:
        return "Вт"
    case .wednesday:
        return "Ср"
    case .thursday:
        return "Чт"
    case .friday:
        return "Пт"
    case .saturday:
        return "Сб"
    case .sunday:
        return "Вс"
    }
}
}
