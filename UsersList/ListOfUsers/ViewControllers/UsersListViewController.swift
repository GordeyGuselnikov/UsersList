//
//  UsersListViewController.swift
//  UsersList
//
//  Created by Gordey Guselnikov on 3/5/24.
//

import UIKit

final class UsersListViewController: UIViewController {
    
    // MARK: - Private Properties
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    private var users: [User] = []
    private var filteredUsers: [User] = []
    // Возвращает true, если строка поиска пустая
    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    // Показывает, происходит ли фильтрация
    private var isFiltering: Bool {
        return !searchBarIsEmpty
    }

    private let networkManager = NetworkManager.shared
    
    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "userCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = .minimal
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
        searchBar.setImage(UIImage(named: "filter"), for: .bookmark, state: .normal)
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(named: "x"), for: .clear, state: .normal)
        searchBar.showsCancelButton = false
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1),
            .font: UIFont.systemFont(ofSize: 16)]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        searchBar.autocapitalizationType = .none
        
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        searchBar.delegate = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Количество строк в таблице.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering
            ? filteredUsers.count
            : users.count
    }
    
    // Настройка ячейки для конкретного индекса
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let user = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    // Обработка выбранной ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //снимать выделение с выбранной ячейки
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedUser = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
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
        tableView.reloadData()
    }
    
    // Вызывается при нажатии на кнопку Search на клавиатуре
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // Фильтрация контента по тексту поиска
    private func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter { user in
            return user.fullName.lowercased().contains(searchText.lowercased()) ||
                user.userTag.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    // Вызывается при нажатии кнопки Filter
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarBookmarkButtonClicked")
        let sheetVC = SortSheetController()
        let navigationVC = UINavigationController(rootViewController: sheetVC)
        
        if let sheet = navigationVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        navigationController?.present(navigationVC, animated: true)
    }
    
}

extension UsersListViewController {
    // Загрузка данных из сети
    private func fetchUsers() {
        networkManager.fetchUser { [weak self] result in
            switch result {
            case .success(let users):
                print(users)
                self?.users = users
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
