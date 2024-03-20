//
//  SortViewController.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 18.03.24.
//

import UIKit

final class SortViewController: UIViewController {

    // MARK: - Private Properties
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Сортировка"
        backButtonSetup()
        
    }
    
    private func backButtonSetup() {
        let backButton = UIBarButtonItem(image: UIImage(named: "Arrow"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(dismissViewController))
        backButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
}
