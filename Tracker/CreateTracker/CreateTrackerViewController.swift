//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Никита Гончаров on 21.01.2024.
//

import UIKit

protocol TrackersActions {
    func appendTracker(tracker: Tracker)
    func reload()
    func showFirstStubScreen()
}

final class CreateTrackerViewController: UIViewController {
    
    var trackersViewController: TrackersActions?
    let cellReuseIdentifier = "CreateTrackersTableViewCell"
    
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    private var selectedCategory: String?
    private var selectedDays: [WeekDay] = []
    private let addCategoryViewController = CategoryViewController()
    private let colors: [UIColor] = [
        .ypColorSelection1, .ypColorSelection2, .ypColorSelection3,
        .ypColorSelection4, .ypColorSelection5, .ypColorSelection6,
        .ypColorSelection7, .ypColorSelection8, .ypColorSelection9,
        .ypColorSelection10, .ypColorSelection11, .ypColorSelection12,
        .ypColorSelection13, .ypColorSelection14, .ypColorSelection15,
        .ypColorSelection16, .ypColorSelection17, .ypColorSelection18
    ]
    
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                                   "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let header: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "Новая привычка"
        header.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        header.textColor = .ypBlackDay
        return header
    }()
    
    private let addTrackerName: UITextField = {
        let addTrackerName = UITextField()
        addTrackerName.translatesAutoresizingMaskIntoConstraints = false
        addTrackerName.placeholder = "Введите название трекера"
        addTrackerName.backgroundColor = .ypBackgroundDay
        addTrackerName.layer.cornerRadius = 16
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        addTrackerName.leftView = leftView
        addTrackerName.leftViewMode = .always
        addTrackerName.keyboardType = .default
        addTrackerName.returnKeyType = .done
        addTrackerName.becomeFirstResponder()
        return addTrackerName
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    private let trackersTableView: UITableView = {
        let trackersTableView = UITableView()
        trackersTableView.translatesAutoresizingMaskIntoConstraints = false
        return trackersTableView
    }()
    
    private lazy var clearButton: UIButton = {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "cleanKeyboard"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        clearButton.isHidden = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 29, height: 17))
        paddingView.addSubview(clearButton)
        addTrackerName.rightView = paddingView
        addTrackerName.rightViewMode = .whileEditing
        return clearButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton: UIButton = UIButton(type: .custom)
        createButton.setTitleColor(.ypWhiteDay, for: .normal)
        createButton.backgroundColor = .ypGray
        createButton.layer.cornerRadius = 16
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitle("Создать", for: .normal)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.isEnabled = false
        return createButton
    }()
    
    private let emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseId)
        collectionView.register(EmojiHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmojiHeaderView.id)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: ColorsCollectionViewCell.reuseId)
        collectionView.register(ColorHeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ColorHeaderViewCell.id)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        addSubviews()
        activateConstraints()
        
        setupTrackerNameTextField()
        setupTrackersTableView()
        setupEmojiCollectionView()
        setupColorCollectionView()
    }

    private func setupTrackerNameTextField() {
        addTrackerName.delegate = self
    }

    private func setupTrackersTableView() {
        trackersTableView.delegate = self
        trackersTableView.dataSource = self
        trackersTableView.register(CreateTrackerViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        trackersTableView.layer.cornerRadius = 16
        trackersTableView.separatorStyle = .none
    }

    private func setupEmojiCollectionView() {
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupColorCollectionView() {
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(header)
        scrollView.addSubview(addTrackerName)
        scrollView.addSubview(trackersTableView)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        scrollView.addSubview(createButton)
        scrollView.addSubview(cancelButton)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            header.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 26),
            header.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            header.heightAnchor.constraint(equalToConstant: 22),
            addTrackerName.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 38),
            addTrackerName.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            addTrackerName.heightAnchor.constraint(equalToConstant: 75),
            addTrackerName.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            addTrackerName.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            trackersTableView.topAnchor.constraint(equalTo: addTrackerName.bottomAnchor, constant: 24),
            trackersTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            trackersTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            trackersTableView.heightAnchor.constraint(equalToConstant: 149),
            emojiCollectionView.topAnchor.constraint(equalTo: trackersTableView.bottomAnchor, constant: 32),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -18),
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 222),
            colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -18),
            cancelButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: colorCollectionView.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            createButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.leadingAnchor.constraint(equalTo: colorCollectionView.centerXAnchor, constant: 4)
        ])
    }
    
    @objc private func clearTextField() {
        addTrackerName.text = ""
        clearButton.isHidden = true
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    // TODO: Добавить сброс заполненных данных
    @objc private func createButtonTapped() {
        guard let text = addTrackerName.text, !text.isEmpty,
              let color = selectedColor,
              let emoji = selectedEmoji else {
            return
        }
        
        let newTracker = Tracker(id: UUID(),
                                 title: text,
                                 color: color,
                                 emoji: emoji,
                                 schedule: self.selectedDays)
        trackersViewController?.appendTracker(tracker: newTracker)
        trackersViewController?.reload()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
// MARK: - SelectedDays
extension CreateTrackerViewController: SelectedDays {
    func save(indicies: [Int]) {
        for index in indicies {
            self.selectedDays.append(WeekDay.allCases[index])
            self.trackersTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.createTrackerViewController = self
            present(scheduleViewController, animated: true, completion: nil)
        }
        trackersTableView.deselectRow(at: indexPath, animated: true)
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
}

// MARK: - UITableViewDataSource
extension CreateTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? CreateTrackerViewCell else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            var title = "Категория"
            if let selectedCategory = selectedCategory {
                title += "\n" + selectedCategory
            }
            cell.update(with: title)
        } else if indexPath.row == 1 {
            var subtitle = ""
            
            if !selectedDays.isEmpty {
                if selectedDays.count == 7 {
                    subtitle = "Каждый день"
                } else {
                    subtitle = selectedDays.map { $0.shortDaysName }.joined(separator: ", ")
                }
            }
            
            if !subtitle.isEmpty {
                cell.update(with: "Расписание\n" + subtitle)
            } else {
                cell.update(with: "Расписание")
            }
        }
        
        return cell
    }
}

// MARK: - UITextFieldDelegate
//добавить медот check по данным 
extension CreateTrackerViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        clearButton.isHidden = textField.text?.isEmpty ?? true
        if textField.text?.isEmpty ?? false {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        } else {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlackDay
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension CreateTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCollectionViewCell", for: indexPath) as? EmojiCollectionViewCell else {
                return UICollectionViewCell()
            }
            let emojiIndex = indexPath.item % emoji.count
            let selectedEmoji = emoji[emojiIndex]
            
            cell.emojiLabel.text = selectedEmoji
            cell.layer.cornerRadius = 16
            
            return cell
        } else if collectionView == colorCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as? ColorsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let colorIndex = indexPath.item % colors.count
            let selectedColor = colors[colorIndex]
            
            cell.colorView.backgroundColor = selectedColor
            cell.layer.cornerRadius = 8
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView:UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView == emojiCollectionView {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmojiHeaderView.id, for: indexPath) as? EmojiHeaderView else {
                return UICollectionReusableView()
            }
            header.headerText = "Emoji"
            return header
        } else if collectionView == colorCollectionView {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ColorHeaderViewCell.id, for: indexPath) as? ColorHeaderViewCell else {
                return UICollectionReusableView()
            }
            header.headerText = "Цвет"
            return header
        }
        
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width - 36
        let cellWidth = collectionViewWidth / 6
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
}

// MARK: - UICollectionViewDelegate
extension CreateTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.backgroundColor = .ypLightGray
            
            selectedEmoji = cell?.emojiLabel.text
        } else if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = cell?.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
            
            selectedColor = cell?.colorView.backgroundColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.backgroundColor = .ypWhiteDay
        } else if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell
            cell?.layer.borderWidth = 0
        }
    }
}
