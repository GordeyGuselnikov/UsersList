//
//  DepartmentCell.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 22.03.24.
//

import UIKit

class DepartmentCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    let departmentLabel = UILabel()
    let selectedCellView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configDepartmentCell(with department: Departments?) {
        guard let department else { return }
        departmentLabel.text = department.title
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        addSubview(departmentLabel)
        addSubview(selectedCellView)
        setupCellView()
        configureDepartmentLabel()
        
        departmentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            departmentLabel.topAnchor.constraint(equalTo: self.topAnchor),
            departmentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            departmentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])

        selectedCellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectedCellView.topAnchor.constraint(equalTo: departmentLabel.bottomAnchor),
            selectedCellView.leadingAnchor.constraint(equalTo: departmentLabel.leadingAnchor, constant: -12),
            selectedCellView.trailingAnchor.constraint(equalTo: departmentLabel.trailingAnchor, constant: 12),
            selectedCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            selectedCellView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupCellView() {
        // цвет полоски
        selectedCellView.backgroundColor = UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1)
        selectedCellView.isHidden = true
    }
    
    private func configureDepartmentLabel() {
        departmentLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        departmentLabel.font = UIFont(name: "Inter-Medium", size: 15)
    }
}
