//
//  ViewController.swift
//  UsersList
//
//  Created by Gordey Guselnikov on 3/5/24.
//

import UIKit

final class UsersListViewController: UIViewController {
    
    let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
//    private let searchBar = UISearchBar()
    
    private var users: [User] = []
    private var filteredUsers: [User] = []
    private var searchBarIsEmpty: Bool { // возвращает true если строка поиска пустая
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
//        setupSearchBar()
        setupSearchController()
        fetchUsers()
        
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredUsers.count : users.count
//        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        guard let cell = cell as? UserCell else { return UITableViewCell() }
        let cell = UserCell()
    
        let user = users[indexPath.row]
//        cell.fullName = user.fullName
        cell.user = user
        
        return cell
    }
    
}

extension UsersListViewController: UISearchResultsUpdating {
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введи имя, тег, почту..."
        searchController.searchBar.tintColor = .purple
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
//        navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.hidesNavigationBarDuringPresentation = false
//        navigationItem.searchController = searchController
//        searchController
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter({ (user: User) -> Bool in
            return user.fullName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}

extension UsersListViewController {
    
    private func fetchUsers() {
        networkManager.fetchUser { [weak self] result in
            switch result {
            case .success(let users):
                print(users)
                //self?.showAlert(withStatus: .success)
                self?.users = users
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
                // self?.showAlert(withStatus: .failed)
            }
        }
    }
    
}

