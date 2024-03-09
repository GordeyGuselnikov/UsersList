//
//  ViewController.swift
//  UsersList
//
//  Created by Gordey Guselnikov on 3/5/24.
//

import UIKit

final class UsersListViewController: UIViewController {

    let tableView = UITableView()
    
    private var users = [User]()
    private let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
        downloadDate()
        
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func downloadDate() {
        NetworkManager.shared.fetchUser { [weak self] result in
            switch result {
            case .success(let users):
                print(users.count)
                print(users)
                //self?.showAlert(withStatus: .success)
                self?.users = users
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
//                self?.showAlert(withStatus: .failed)
            }
        }

    }
    
    
}

extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            users.count
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
            let user = users[indexPath.row]
    
            var content = cell.defaultContentConfiguration()
//            content.text = user.firstName
            content.text = user.fullName
            content.secondaryText = user.department.title + " " + user.position
//            content.text = "dsfdfsdfsdf"
//            print(user.avatarUrl)
            cell.contentConfiguration = content
    
            return cell
        }
    
}


    

    
    
    




