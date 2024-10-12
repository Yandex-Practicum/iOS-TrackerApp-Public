import UIKit

final class CategoryViewController: UIViewController {

    var onCategorySelected: ((String) -> Void)?
    var onCategoriesUpdated: (() -> Void)?
    
    private var viewModel: CategoryViewModel
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var selectedCategory: String?

    // Индекс выбранной категории
    private var selectedIndexPath: IndexPath?

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
        label.text = """
                        Привычки и события можно\n
                        объединить по смыслу
                        """
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.backgroundColor = .tableBackground
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = .createButtonActive
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()

    init(viewModel: CategoryViewModel, selectedCategory: String?) {
        self.viewModel = viewModel
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedCategory = selectedCategory, let index = viewModel.indexOfCategory(named: selectedCategory) {
            selectedIndexPath = IndexPath(row: index, section: 0)
            print("Выбранная категория: \(selectedCategory), Индекс: \(index)")
        } else {
            print("Нет выбранной категории или она не найдена в списке")
        }
        
        setupNavigationBar()
        setupViews()
        setupBindings()
        viewModel.loadCategories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadCategories()
        tableView.reloadData()
    }

    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Категория"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ]
    }

    private func setupViews() {
        view.backgroundColor = .white

        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(activityIndicator)
        view.addSubview(placeholderView)
        placeholderView.addSubview(placeholderImageView)
        placeholderView.addSubview(placeholderLabel)

        // Layout
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0) // Начальная высота 0
        tableViewHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            // TableView
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Add Button
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 60),

            // Установка максимальной высоты таблицы
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: addButton.topAnchor, constant: -16),
            
            // Placeholder View
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            // Placeholder Image
            placeholderImageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),

            // Placeholder Label
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            
            // Центрирование индикатора активности
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        // Обязательно перемещаем индикатор на передний план
        view.bringSubviewToFront(activityIndicator)
    }

    private func setupBindings() {
        viewModel.onCategoriesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }

    private func updateUI() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()

                let hasCategories = self.viewModel.hasCategories()

                self.tableView.isHidden = !hasCategories
                self.placeholderView.isHidden = hasCategories

                let contentHeight = CGFloat(self.viewModel.categoriesCount) * 75
                self.tableViewHeightConstraint?.constant = min(contentHeight, 450)

                if let selectedCategory = self.selectedCategory, let index = self.viewModel.indexOfCategory(named: selectedCategory) {
                    self.selectedIndexPath = IndexPath(row: index, section: 0)
                    print("Обновленный индекс выбранной категории: \(index)")
                }

                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
            }
        }
    }
    
    private func editCategory(_ category: TrackerCategory) {
        let formViewModel = CategoryFormViewModel(categoryStore: viewModel.categoryStore)
        formViewModel.categoryTitle = category.title // Устанавливаем текущее название категории

        let editCategoryVC = CategoryFormViewController(viewModel: formViewModel, category: category)
        editCategoryVC.onCategorySaved = { [weak self] in
            self?.viewModel.loadCategories() // Обновляем список категорий
            self?.onCategoriesUpdated?() // Уведомляем о том, что категории обновились
        }
        
        let navigationController = UINavigationController(rootViewController: editCategoryVC)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func deleteCategory(at indexPath: IndexPath) {
        let category = viewModel.categoryTitle(at: indexPath.row)
        viewModel.deleteCategory(at: indexPath.row)
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }, completion: { _ in
            self.updateUI()
        })
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoriesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }

        let category = viewModel.categoryTitle(at: indexPath.row)
        let isLast = indexPath.row == viewModel.categoriesCount - 1
        let isSelected = selectedIndexPath == indexPath

        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(contextMenuInteraction)
        
        cell.configure(with: category, showBottomSeparator: !isLast, isSelected: isSelected)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = viewModel.categoryTitle(at: indexPath.row)
        print("Выбрана категория: \(selectedCategory)")
        
        onCategorySelected?(selectedCategory)
        
        if let previousIndexPath = selectedIndexPath {
            tableView.reloadRows(at: [previousIndexPath], with: .none)
        }
        
        selectedIndexPath = indexPath
        print("Индекс выбранной ячейки: \(indexPath.row)")
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension CategoryViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let locationInTableView = interaction.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: locationInTableView) else {
            return nil
        }

        let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
            self?.showDeleteConfirmation(for: indexPath)
        }

        let editAction = UIAction(title: "Редактировать") { [weak self] _ in
            guard let category = self?.viewModel.categories[indexPath.row] else { return }
            self?.editCategory(category)
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
    
    private func showDeleteConfirmation(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: "Эта категория точно не нужна?", preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.deleteCategory(at: indexPath)
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension CategoryViewController {

    @objc private func addCategoryButtonTapped() {
        let formViewModel = CategoryFormViewModel(categoryStore: viewModel.categoryStore)
        let formViewController = CategoryFormViewController(viewModel: formViewModel)

        formViewController.onCategorySaved = { [weak self] in
            self?.viewModel.loadCategories()
            self?.onCategoriesUpdated?()
        }

        let navigationController = UINavigationController(rootViewController: formViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

final class CategoryCell: UITableViewCell {

    static let reuseIdentifier = "CategoryCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private let bottomSeparator: UIView = {
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(bottomSeparator)
        
        NSLayoutConstraint.activate([
            // Позиционирование заголовка
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Позиционирование галочки
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Позиционирование нижнего сепаратора
            bottomSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bottomSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bottomSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configure(with title: String, showBottomSeparator: Bool, isSelected: Bool) {
        titleLabel.text = title
        checkmarkImageView.isHidden = !isSelected
        contentView.backgroundColor = .tableBackground
        bottomSeparator.isHidden = !showBottomSeparator
    }
}
