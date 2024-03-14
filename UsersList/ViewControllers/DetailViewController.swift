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
        // Do any additional setup after loading the view.
        
    }
    
    private func setupViews() {
        view.addSubview(photoImageView)
        configurePhotoImageView()
    }
    
    private func configurePhotoImageView() {
        photoImageView.layer.cornerRadius = 52
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
    }
    
    private func setValues(for user: User) {
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
