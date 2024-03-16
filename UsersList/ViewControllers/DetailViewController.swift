//
//  DetailViewController.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 15.03.24.
//

import UIKit

final class DetailViewController: UIViewController {
    
    var user: User!
    
    let photoImageView = UIImageView()
    private let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupUser()
        // Do any additional setup after loading the view.
        
    }
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
