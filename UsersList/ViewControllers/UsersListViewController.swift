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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.topAnchor.constraint(equalTo: view.),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchUsers() {
        NetworkManager.shared.fetchUser { [weak self] result in
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
        cell.fullName = user.fullName
        
        return cell
    }
    
}

extension UsersListViewController: UISearchResultsUpdating {
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .white
//        navigationItem.hidesSearchBarWhenScrolling = false
//        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter({ (user: User) -> Bool in
            return user.fullName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}

//    func configure(with user: User) -> UIListContentConfiguration {
//
//        var content = cell.defaultContentConfiguration()
//
//        content.text = user.fullName
//        content.secondaryText = user.department.title + " " + user.position
//        content.image = UIImage(systemName: "bicycle")
//
//        print(user.avatarUrl)
//
//        networkManager.fetchImageData(from: user.avatarUrl) { [weak self] result in
//            switch result {
//            case .success(let imageData):
//                content.image = UIImage(data: imageData)
//                cell.contentConfiguration = content
//            case .failure(let error):
//                print(error)
////                self?.showAlert(withStatus: .failed)
//            }
//        }
//        return content
//    }









