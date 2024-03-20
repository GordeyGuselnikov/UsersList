//
//  PhoneView.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 19.03.24.
//

import UIKit

final class PhoneView: UIView {
    
    let numberLabel = UILabel()
    let phoneImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(numberLabel)
        addSubview(phoneImageView)
        backgroundColor = .white
        
        configureProfilePhoneNumberLabel()
        configureProfilePhoneImage()
        
        
        phoneImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            phoneImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            phoneImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            phoneImageView.widthAnchor.constraint(equalToConstant: 24),
            phoneImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: phoneImageView.centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: phoneImageView.trailingAnchor, constant: 12),
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func configureProfilePhoneNumberLabel() {
        numberLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        numberLabel.font = UIFont(name: "Inter-Medium", size: 16)
        numberLabel.isUserInteractionEnabled = true
    }
    
    private func configureProfilePhoneImage() {
        phoneImageView.clipsToBounds = true
        phoneImageView.contentMode = .scaleAspectFill
        phoneImageView.image = UIImage(named: "phone")
    }

}
