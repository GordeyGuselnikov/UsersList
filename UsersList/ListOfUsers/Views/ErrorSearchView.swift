//
//  ErrorSearchView.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 23.03.24.
//

import UIKit

final class ErrorSearchView: UIView {
    // MARK: - Private Properties
    private let errorImageLabel = UILabel()
    private let reasonLabel = UILabel()
    private let adviceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(errorImageLabel)
        addSubview(reasonLabel)
        addSubview(adviceLabel)
        backgroundColor = .white
        
        configErrorImageView()
        configErrorTitleLabel()
        configDescriptionLabel()
        
        NSLayoutConstraint.activate([
            errorImageLabel.topAnchor.constraint(equalTo: topAnchor),
            errorImageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageLabel.heightAnchor.constraint(equalToConstant: 56),
            errorImageLabel.widthAnchor.constraint(equalToConstant: 56),
            
            reasonLabel.topAnchor.constraint(equalTo: errorImageLabel.bottomAnchor, constant: 8),
            reasonLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            adviceLabel.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: 12),
            adviceLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    // MARK: - Private Methods
    private func configErrorImageView() {
        errorImageLabel.text = "🔍"
        errorImageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configErrorTitleLabel() {
        reasonLabel.text = "Мы никого не нашли"
        reasonLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        reasonLabel.font = UIFont(name: "Inter-SemiBold", size: 17)
        reasonLabel.textAlignment = .center
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configDescriptionLabel() {
        adviceLabel.text = "Попробуй скорректировать запрос"
        adviceLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        adviceLabel.font = UIFont(name: "Inter-Regular", size: 16)
        adviceLabel.textAlignment = .center
        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
