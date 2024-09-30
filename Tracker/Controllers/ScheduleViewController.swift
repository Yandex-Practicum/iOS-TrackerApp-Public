import UIKit

final class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: ScheduleViewControllerDelegate?
    private let daysOfWeek: [DayOfWeek] = DayOfWeek.allCases
    private var selectedDays: [DayOfWeek]

    init(selectedDays: [DayOfWeek]) {
        self.selectedDays = selectedDays
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.backgroundColor = UIColor.systemGray6
        tableView.separatorStyle = .none
        return tableView
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupNavigationBar() {
        navigationItem.title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
    }

    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -47),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func doneButtonTapped() {
        // Преобразуем массив из DayOfWeek в массив строк
        let selectedDayStrings = selectedDays.map { $0.rawValue }
        print("Delegate is \(delegate != nil ? "set" : "nil")")
        delegate?.didSelectDays(selectedDayStrings)
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as! ScheduleCell
        let day = daysOfWeek[indexPath.row]
        // Показываем полное название дня недели
        cell.configure(with: day.fullName, isSelected: selectedDays.contains(day), isFirst: indexPath.row == 0)
//        cell.switchAction = { [weak self] isOn in
//            if isOn {
//                self?.selectedDays.append(day)
//            } else {
//                self?.selectedDays.removeAll { $0 == day }
//            }
//        }
        cell.switchAction = { isOn in
            if isOn {
                self.selectedDays.append(day)
            } else {
                self.selectedDays.removeAll { $0 == day }
            }
        }
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let availableHeight = tableView.frame.height
        let rowHeight = availableHeight / CGFloat(daysOfWeek.count)
        return rowHeight > 75 ? rowHeight : 75
    }
}

final class ScheduleCell: UITableViewCell {
    
    static let reuseIdentifier = "ScheduleCell"
    
    var switchAction: ((Bool) -> Void)?
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let daySwitch: UISwitch = {
        let daySwitch = UISwitch()
        daySwitch.onTintColor = UIColor(resource: .switcherOn)
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        return daySwitch
    }()
    
    private let topSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(daySwitch)
        contentView.addSubview(topSeparator)
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            topSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            topSeparator.topAnchor.constraint(equalTo: contentView.topAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        daySwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
    }
    
    func configure(with day: String, isSelected: Bool, isFirst: Bool) {
        dayLabel.text = day
        daySwitch.isOn = isSelected
        contentView.backgroundColor = UIColor(resource: .tableBackground)
        topSeparator.isHidden = isFirst
    }
    
    @objc private func switchToggled(_ sender: UISwitch) {
        switchAction?(sender.isOn)
    }
}

@available(iOS 17, *)
#Preview {
    ScheduleViewController(selectedDays: [])
}
