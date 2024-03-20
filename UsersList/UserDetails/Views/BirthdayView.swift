//
//  BirthdayView.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 19.03.24.
//

import UIKit

final class BirthdayView: UIView {
    
    let dateOfBirthLabel = UILabel()
    let ageLabel = UILabel()
    let starImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(starImageView)
        addSubview(dateOfBirthLabel)
        addSubview(ageLabel)
        backgroundColor = .white
        
        configureDateOfBirthLabel()
        configureAgeLabel()
        configureStarImageView()
        
        
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            starImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        dateOfBirthLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateOfBirthLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 12)
        ])
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ageLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            ageLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func configureDateOfBirthLabel() {
        dateOfBirthLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        dateOfBirthLabel.font = UIFont(name: "Inter-Medium", size: 16)
    }
    
    private func configureAgeLabel() {
        ageLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        ageLabel.font = UIFont(name: "Inter-Medium", size: 16)
    }
    
    private func configureStarImageView() {
        starImageView.clipsToBounds = true
        starImageView.contentMode = .scaleAspectFill
        starImageView.image = UIImage(named: "star")
    }
    
}
