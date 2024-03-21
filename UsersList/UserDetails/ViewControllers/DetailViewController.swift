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
    private let containerView = UIView()
    private let nameStackView = UIStackView()
    private let fullNameLabel = UILabel()
    private let userTagLabel = UILabel()
    private let positionLabel = UILabel()
    
    private let birthdayView = BirthdayView()
    private let phoneView = PhoneView()
    
    private let networkManager = NetworkManager.shared

    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupBackButton()
        
        setupUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the Navigation Bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(photoImageView)
//        containerView.addSubview(fullNameLabel)
//        containerView.addSubview(userTagLabel)
        containerView.addSubview(nameStackView)
        nameStackView.addArrangedSubview(fullNameLabel)
        nameStackView.addArrangedSubview(userTagLabel)
        containerView.addSubview(positionLabel)
        
        view.addSubview(birthdayView)
        view.addSubview(phoneView)
        
        configureContainerView()
        configureNameStackView()
        configurePhotoImageView()
        
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 72),
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 104),
            photoImageView.widthAnchor.constraint(equalToConstant: 104)
        ])

        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 24),
            nameStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            positionLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 12),
            positionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            positionLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 280)
        ])
        
        birthdayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            birthdayView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            birthdayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            birthdayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        phoneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneView.topAnchor.constraint(equalTo: birthdayView.bottomAnchor),
            phoneView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            phoneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem(
            image: UIImage(named: "chevron"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        // Установка кнопки "Назад" в качестве левой кнопки элемента навигации
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configurePhotoImageView() {
        photoImageView.backgroundColor = .white
        photoImageView.layer.cornerRadius = 52
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
    }
    
    private func configureContainerView() {
        containerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1)
    }
    
    private func configureNameStackView() {
        nameStackView.axis = .horizontal
        nameStackView.alignment = .center
        nameStackView.spacing = 4
    }
    
    private func setupUser() {
        guard let user = user else { return }
        setImage(for: user)
        
        fullNameLabel.text = user.fullName
        fullNameLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        fullNameLabel.font = UIFont(name: "Inter-Bold", size: 24)
        
        userTagLabel.text = user.userTag.lowercased()
        userTagLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        userTagLabel.font = UIFont(name: "Inter-Regular", size: 17)
        
        positionLabel.text = user.position
        positionLabel.textColor = UIColor(red: 0.333, green: 0.333, blue: 0.361, alpha: 1)
        positionLabel.font = UIFont(name: "Inter-Regular", size: 13)
        

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateOfBirth = dateFormatter.date(from: user.birthday) else {
            print("Wrong date format!")
            return
        }
        
        dateFormatter.dateFormat = "d MMMM yyyy"
        birthdayView.dateOfBirthLabel.text = dateFormatter.string(from: dateOfBirth)
        
        let formatAgeString: String = NSLocalizedString("age_years", comment: "")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let yearsOld = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year
//        print(yearsOld!)
        
        if let yearsOld = yearsOld {
            let resultAgeString: String = String.localizedStringWithFormat(formatAgeString, yearsOld)
            birthdayView.ageLabel.text = resultAgeString
        } else {
            print("Failed to calculate age!")
        }
        
        
        phoneView.numberLabel.text = user.phone
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
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
