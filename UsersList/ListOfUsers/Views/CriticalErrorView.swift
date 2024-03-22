//
//  CriticalErrorView.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 23.03.24.
//

import UIKit

final class CriticalErrorView: UIView {
    // MARK: - Public Properties
    let tryAgainButton = UIButton()
    
    // MARK: - Private Properties
    private let errorImageLabel = UILabel()
    private let reasonLabel = UILabel()
    private let messageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(errorImageLabel)
        addSubview(reasonLabel)
        addSubview(messageLabel)
        addSubview(tryAgainButton)
        backgroundColor = .white
        
        configureErrorImageView()
        configureErrorTitleLabel()
        configureDescriptionLabel()
        configureRequestButton()
        
        NSLayoutConstraint.activate([
            errorImageLabel.topAnchor.constraint(equalTo: topAnchor),
            errorImageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageLabel.heightAnchor.constraint(equalToConstant: 56),
            errorImageLabel.widthAnchor.constraint(equalToConstant: 56),
            
            reasonLabel.topAnchor.constraint(equalTo: errorImageLabel.bottomAnchor, constant: 8),
            reasonLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: 12),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tryAgainButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12),
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 20),
            tryAgainButton.widthAnchor.constraint(equalToConstant: 343)
        ])
    }
    
    // MARK: - Configures
    private func configureErrorImageView() {
        errorImageLabel.text = "🛸"
        errorImageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureErrorTitleLabel() {
        reasonLabel.text = "Какой-то сверхразум все сломал"
        reasonLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        reasonLabel.font = UIFont(name: "Inter-SemiBold", size: 17)
        reasonLabel.textAlignment = .center
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDescriptionLabel() {
        messageLabel.text = "Постараемся быстро починить"
        messageLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        messageLabel.font = UIFont(name: "Inter-Regular", size: 16)
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureRequestButton() {
        tryAgainButton.setTitle("Попробовать снова", for: .normal)
        tryAgainButton.backgroundColor = .white
        tryAgainButton.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        tryAgainButton.setTitleColor(UIColor.systemGray4, for: .highlighted)
        tryAgainButton.setTitleColor(UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1), for: .normal)
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
    }
}
