//
//  UsersListViewController.swift
//  UsersList
//
//  Created by Gordey Guselnikov on 3/5/24.
//

import UIKit

// Протокол для передачи sortType с SortSheet в этот Контроллер
protocol SortSheetControllerDelegate: AnyObject {
    func setSort(sortType: SortType)
}
// Протокол для передачи департамента с TabMenu в этот Контроллер
protocol TabMenuCollectionViewDelegate: AnyObject {
    func setFilter(byDepartment: Departments)
}

final class UsersListViewController: UIViewController {
    // MARK: - Private Properties
    private let searchBar = UISearchBar()
    private let tabMenu = TabMenuCollectionView()
    private let tableView = UITableView()
    private var errorSearchView = ErrorSearchView()
    private let criticalErrorView = CriticalErrorView()
    private let refreshControl = UIRefreshControl()
    
    private var users: [User] = []
    private var filteredUsers: [User] = []
    private var currentSortType: SortType = .alphabet
    private var currentFilter: Departments = .all
    private let networkManager = NetworkManager.shared
    
    // Свойство для хранения текста поиска
    private var savedSearchText: String = ""
    // Возвращает true, если строка поиска пустая
    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    // Показывает, происходит ли поиск
    private var isSearching: Bool {
        return !searchBarIsEmpty
    }
    // Показывает, происходит ли фильтрация
    private var isFiltering = false
    
    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        pullToRefreshSetup()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Override Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tabMenu)
        view.addSubview(tableView)
        view.addSubview(errorSearchView)
        view.addSubview(criticalErrorView)
        
        setupCriticalErrorView()
        errorSearchView.isHidden = true
        
        configSearchBar()
        configTabMenu()
        configTableView()
        
        // MARK: - Set Constraints
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            tabMenu.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tabMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tabMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabMenu.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tabMenu.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        errorSearchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorSearchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 220),
            errorSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            errorSearchView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        criticalErrorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            criticalErrorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            criticalErrorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            criticalErrorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            criticalErrorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCriticalErrorView() {
        criticalErrorView.tryAgainButton.addTarget(self, action: #selector(requestAgain), for: .touchUpInside)
        criticalErrorView.isHidden = true
    }
    
    @objc private func requestAgain() {
        print("Attempting to fetch user data again")
        fetchUsers()
    }
    
    private func configTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "userCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        
        searchBar.searchTextField.layer.cornerRadius = 16
        searchBar.searchTextField.clipsToBounds = true
        
        searchBar.setImage(UIImage(named: "lightSearch"), for: .search, state: .normal)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Введи имя, тег, почту ...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(
                red: 0.76,
                green: 0.76,
                blue: 0.78,
                alpha: 1
            )]
        )
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.tintColor = UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1)
        }
        // Кнопка Фильтр
        searchBar.setImage(UIImage(named: "filter"), for: .bookmark, state: .normal)
        searchBar.showsBookmarkButton = true
        // Кнопка х - Очистить
        searchBar.setImage(UIImage(named: "x"), for: .clear, state: .normal)
        searchBar.showsCancelButton = false
        // Кнопка Cancel - Отмена
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .title = "Отмена"
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1),
            .font: UIFont.systemFont(ofSize: 16)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        // Инициализация delegate для searchBar экземпляром класса UsersListViewController
        // UsersListViewController будет отвечать за обработку событий searchBar
        searchBar.delegate = self
    }
    
    private func configTabMenu() {
        tabMenu.translatesAutoresizingMaskIntoConstraints = false
        
        // Инициализация delegate для tabMenu экземпляром класса UsersListViewController
        // UsersListViewController будет получать уведомления от tabMenu
        tabMenu.filterDelegate = self
    }
    
    private func pullToRefreshSetup() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func didPullToRefresh() {
        fetchUsers()
        refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    // Количество строк в таблице.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching || isFiltering
        ? filteredUsers.count
        : users.count
    }
    
    // Настройка ячейки для конкретного индекса
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let user = isSearching || isFiltering
            ? filteredUsers[indexPath.row]
            : users[indexPath.row]
        
        cell.user = user
        return cell
    }
    
    // Обработка выбранной ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //снимать выделение с выбранной ячейки
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedUser = isSearching || isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.user = selectedUser
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension UsersListViewController: UISearchBarDelegate {
    // Вызывается, когда пользователь начинает редактировать текст в поисковом поле
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setImage(UIImage(named: "darkSearch"), for: .search, state: .normal)
        searchBar.placeholder = ""
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsBookmarkButton = false
    }
    
    // Вызывается, когда изменяется текст в поисковом поле
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        savedSearchText = searchText
        filterContentForSearchText(searchText)
    }
    
    // Вызывается, когда пользователь нажимает кнопку "Отмена" в поисковом поле
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setImage(UIImage(named: "lightSearch"), for: .search, state: .normal)
        searchBar.placeholder = "Введи имя, тег, почту ..."
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsBookmarkButton = true
        searchBar.resignFirstResponder()
        searchBar.text = nil
        savedSearchText = ""
        tableView.reloadData()
    }
    
    // Вызывается при нажатии на кнопку Search на клавиатуре
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        let searchTextLowercased = searchText.lowercased()
        let filteredUsersByDepartment = currentFilter == .all ? users : users.filter { $0.department == currentFilter }
        
        filteredUsers = searchText.isEmpty
        ? filteredUsersByDepartment
        : filteredUsersByDepartment.filter { user in
            return user.fullName.lowercased().contains(searchTextLowercased) ||
            user.userTag.lowercased().contains(searchTextLowercased)
        }
        
        errorSearchView.isHidden = !filteredUsers.isEmpty
        tableView.reloadData()
    }

    // Вызывается при нажатии кнопки BookmarkButton (Сортировка)
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarBookmarkButtonClicked")
        let sheetVC = SortSheetController()
        let navigationVC = UINavigationController(rootViewController: sheetVC)
        
        sheetVC.sortDelegate = self
        sheetVC.selectedSortType = currentSortType
        
        if let sheet = navigationVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        navigationController?.present(navigationVC, animated: true)
    }
    
}

// MARK: - Загрузка данных из сети
extension UsersListViewController {
    private func fetchUsers() {
        networkManager.fetchUser { [weak self] result in
            switch result {
            case .success(let users):
                print(users)
                self?.users = users
                self?.applySorting()
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - SortSheetControllerDelegate
extension UsersListViewController: SortSheetControllerDelegate {
    // Устанавливает тип сортировки и применяет его к отфильтрованным данным
    func setSort(sortType: SortType) {
        print("Current sortType: \(sortType)")
        currentSortType = sortType
        
        applySorting()
        tableView.reloadData()
    }
}

// MARK: - TabMenuCollectionViewDelegate
extension UsersListViewController: TabMenuCollectionViewDelegate {
    // Устанавливает фильтр по департаменту и применяет его
    func setFilter(byDepartment: Departments) {
        print("Current department: \(byDepartment)")
        currentFilter = byDepartment
        
        applyFilter()
        filterContentForSearchText(savedSearchText)
        tableView.reloadData()
    }
    
    // Применение текущего фильтра по департаменту
    private func applyFilter() {
        switch currentFilter {
        case .all:
            isFiltering = false
            filteredUsers = users
        default:
            isFiltering = true
            filteredUsers = users.filter { $0.department == currentFilter }
        }
        applySorting()
    }
    
    // Применение текущей сортировки
    private func applySorting() {
        switch currentSortType {
        case .alphabet:
            users.sort { $0.fullName < $1.fullName }
            filteredUsers.sort { $0.fullName < $1.fullName }
        case .birthday:
            users.sort { $0.birthday < $1.birthday }
            filteredUsers.sort { $0.birthday < $1.birthday }
        }
    }
}
