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
    
    private var users: [User] = []
    private var filteredUsers: [User] = []
    // возвращает true если строка поиска пустая
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchUsers()
        
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        setupTableView()
        setupSearchController()
    }
    
    func setupTableView() {
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(UserCell.self, forCellReuseIdentifier: "cell")
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
//        let user = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
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
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter({ (user: User) -> Bool in
            return user.fullName.lowercased().contains(searchText.lowercased()) ||
            user.userTag.lowercased().contains(searchText.lowercased())
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

