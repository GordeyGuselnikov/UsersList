//
//  ViewController.swift
//  UsersList
//
//  Created by Gordey Guselnikov on 3/5/24.
//

import UIKit

final class UsersListViewController: UIViewController {
    
    let tableView = UITableView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchUsers()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Введи имя, тег, почту..."
        searchBar.tintColor = .purple
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.showsCancelButton = false
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("Отмена", for: .normal)
            cancelButton.setTitleColor(.black, for: .normal) // Устанавливаем цвет текста
        }
        searchBar.autocapitalizationType = .none
        
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        searchBar.delegate = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let user = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.user = selectedUser
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension UsersListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter { user in
            return user.fullName.lowercased().contains(searchText.lowercased()) ||
                user.userTag.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension UsersListViewController {
    
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
