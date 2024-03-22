//
//  RadioButtonView.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 21.03.24.
//

import UIKit

final class RadioButtonView: UIView {
    
    let radioButton = UIButton()
    let sortNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(radioButton)
        addSubview(sortNameLabel)
        backgroundColor = .white
        
        configureRadioButton()
        configureSortNameLabel()
        
        // Констрейнты для selectButton
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radioButton.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            radioButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            radioButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
        ])
        
        // Констрейнты для descriptionLabel
        sortNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortNameLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 12),
            sortNameLabel.centerYAnchor.constraint(equalTo: radioButton.centerYAnchor)
        ])
    }
    
    private func configureRadioButton() {
        radioButton.setImage(UIImage(named: "isOff"), for: .normal)
        radioButton.setImage(UIImage(named: "isOn"), for: .selected)
        radioButton.addTarget(self, action: #selector(radioButtonSelected), for: .touchUpInside)
    }
    
    @objc func radioButtonSelected(sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    private func configureSortNameLabel() {
        sortNameLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        sortNameLabel.font = UIFont(name: "Inter-Medium", size: 16)
        sortNameLabel.textAlignment = .center
    }
}
