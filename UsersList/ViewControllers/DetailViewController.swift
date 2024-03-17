//
//  DetailViewController.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 15.03.24.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Public Properties
    var user: User!
    
    // MARK: - Private Properties
    private let photoImageView = UIImageView()
    private let networkManager = NetworkManager.shared

    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupUser()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.addSubview(photoImageView)
        view.backgroundColor = .white
        photoImageView.backgroundColor = .white
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 104),
            photoImageView.heightAnchor.constraint(equalToConstant: 104)
        ])
        
        photoImageView.layer.cornerRadius = 52
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
        
    }
    
//    private func configurePhotoImageView() {
//        
//    }
    
    private func setupUser() {
        guard let user = user else { return }
        setImage(for: user)
    }
    
    private func setImage(for user: User) {
        networkManager.fetchImageData(from: user.avatarUrl) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.photoImageView.image = UIImage(data: imageData)
//                self?.contentConfiguration = content
            case .failure(let error):
                print(error)
//                self?.showAlert(withStatus: .failed)
            }
        }
    }
}
