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
    private let errorTitleLabel = UILabel()
    private let errorDescriptionLabel = UILabel()
    
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
        addSubview(errorTitleLabel)
        addSubview(errorDescriptionLabel)
        backgroundColor = .white
        
        configErrorImageView()
        configErrorTitleLabel()
        configDescriptionLabel()
        
        NSLayoutConstraint.activate([
            errorImageLabel.topAnchor.constraint(equalTo: topAnchor),
            errorImageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageLabel.heightAnchor.constraint(equalToConstant: 56),
            errorImageLabel.widthAnchor.constraint(equalToConstant: 56),
            
            errorTitleLabel.topAnchor.constraint(equalTo: errorImageLabel.bottomAnchor, constant: 8),
            errorTitleLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            errorDescriptionLabel.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor, constant: 12),
            errorDescriptionLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    // MARK: - Private Methods
    private func configErrorImageView() {
        errorImageLabel.text = "🔍"
        errorImageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configErrorTitleLabel() {
        errorTitleLabel.text = "Мы никого не нашли"
        errorTitleLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        errorTitleLabel.font = UIFont(name: "Inter-SemiBold", size: 17)
        errorTitleLabel.textAlignment = .center
        errorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configDescriptionLabel() {
        errorDescriptionLabel.text = "Попробуй скорректировать запрос"
        errorDescriptionLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        errorDescriptionLabel.font = UIFont(name: "Inter-Regular", size: 16)
        errorDescriptionLabel.textAlignment = .center
        errorDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
