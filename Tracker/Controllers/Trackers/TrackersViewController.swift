import UIKit

final class TrackersViewController: UIViewController {

    // MARK: - Properties
    private var trackerCategories: ([TrackerCategory], [UUID: Bool], [UUID: Int]) = ([], [:], [:])
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var trackerService: TrackerService?
    
    init() {
        super.init(nibName: nil, bundle: nil) // Вызов инициализатора родительского класса
        
        // Получаем ссылку на AppDelegate и извлекаем trackerService
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.trackerService = appDelegate.trackerService
        }
        
        // Настраиваем замыкание на обновление данных
        self.trackerService?.onTrackersUpdated = { [weak self] in
            guard let self = self else { return }
            self.loadTrackers(for: self.datePicker.date)  // Обновляем трекеры, когда они изменяются
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private lazy var topContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.layer.masksToBounds = true
        return searchBar
    }()

    private lazy var placeholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 9

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        setupViews()
        setupConstraints()
        setupCollectionView()
        setupActivityIndicator()
        loadTrackers(for: Date())
    }

    // MARK: - Setup Methods

    private func setupViews() {
        view.backgroundColor = .white

        view.addSubview(topContainerView)
        topContainerView.addSubview(titleLabel)
        topContainerView.addSubview(searchBar)

        view.addSubview(collectionView)

        view.addSubview(placeholderView)
        placeholderView.addSubview(placeholderImageView)
        placeholderView.addSubview(placeholderLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Top Container View
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 16),

            // Search Bar
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            topContainerView.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),

            // Collection View
            collectionView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // Placeholder View
            placeholderView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // Placeholder Image
            placeholderImageView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
            placeholderImageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),

            // Placeholder Label
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor)
        ])
    }

    private func setupNavigationBar() {
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(named: "pluse")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addButton.addTarget(self, action: #selector(addTracker), for: .touchUpInside)

        let addButtonContainer = UIView()
        addButtonContainer.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: addButtonContainer.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: addButtonContainer.trailingAnchor),
            addButton.topAnchor.constraint(equalTo: addButtonContainer.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: addButtonContainer.bottomAnchor)
        ])

        guard let navigationBar = navigationController?.navigationBar else {
            print("Navigation bar не найден")
            return
        }
        
        navigationBar.addSubview(addButtonContainer)
        addButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButtonContainer.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 6),
            addButtonContainer.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])

        let datePickerContainer = UIBarButtonItem(customView: datePicker)
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        navigationItem.rightBarButtonItem = datePickerContainer
    }

    private func setupActions() {
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        searchBar.delegate = self
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(
            TrackerCategoryHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCategoryHeader.identifier
        )
    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Загрузка данных
    private func loadTrackers(for date: Date) {
        activityIndicator.startAnimating()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            // Получаем обновленные трекеры для конкретной даты
            guard let (trackerCategories, completedTrackers, completedCount) = self.trackerService?.fetchTrackers(for: date) else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating() // Останавливаем индикатор, если данные не были загружены
                }
                print("Загруженные категории:")
                for category in trackerCategories.0 {
                    print("Категория: \(category.title), Трекеры: \(category.trackers.count)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.trackerCategories = (trackerCategories, completedTrackers, completedCount)
                self.collectionView.reloadData()  // Перезагружаем коллекцию с новыми данными
                self.updatePlaceholderVisibility()
                self.activityIndicator.stopAnimating()
            }
        }
    }

    private func updatePlaceholderVisibility() {
        let hasTrackers = !trackerCategories.0.isEmpty
        placeholderView.isHidden = hasTrackers
        collectionView.isHidden = !hasTrackers
    }

    // MARK: - Actions

    @objc private func addTracker() {
        let createTrackerVC = CreateTrackerTypeViewController()
        createTrackerVC.modalPresentationStyle = .pageSheet
        createTrackerVC.modalTransitionStyle = .coverVertical

        // Обновляем список трекеров после добавления нового
        createTrackerVC.onTrackerAdded = { [weak self] in
            self?.loadTrackers(for: self?.datePicker.date ?? Date())
        }

        let navigationController = UINavigationController(rootViewController: createTrackerVC)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        loadTrackers(for: sender.date)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerCategories.0.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerCategories.0[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }

        let tracker = trackerCategories.0[indexPath.section].trackers[indexPath.item]
        
        // Получаем количество выполнений для этого трекера
        let completedCount = trackerCategories.2[tracker.id] ?? 0
        
        // Проверяем, завершен ли трекер, используя словарь completedTrackers
        let isCompleted = trackerCategories.1[tracker.id] ?? false
        
        let isFutureDate = datePicker.date > Date()
        
        print("Статус трекера \(tracker.name): \(isCompleted ? "выполнен" : "невыполнен")")
        
        cell.configure(with: tracker, isCompleted: isCompleted, completedCount: completedCount, isFutureDate: isFutureDate)
        
        // Передаем логику для нажатия на кнопку
        cell.didTapActionButton = { [weak self] in
            guard let self = self else { return }
            // Обновляем статус трекера
            self.trackerService?.completeTracker(tracker, on: self.datePicker.date)
            self.loadTrackers(for: self.datePicker.date)  // Перезагружаем трекеры
        }
        
        return cell
    }

    // Заголовок секции
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerCategoryHeader.identifier,
                for: indexPath
            ) as? TrackerCategoryHeader else {
                return UICollectionReusableView()
            }
            let categoryTitle = trackerCategories.0[indexPath.section].title
            header.configure(with: categoryTitle)
            return header
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace: CGFloat = 16 * 2 + 9
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = floor(availableWidth / 2)
        return CGSize(width: widthPerItem, height: 148)
    }

    // Размер заголовка секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 55)
    }

    // Отступы для секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    // Межстрочный интервал
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //return 0
        .zero
    }

    // Интервал между элементами в строке
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //return 0
        .zero
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    // добавить поиск
}
