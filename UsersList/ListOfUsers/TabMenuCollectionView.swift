//
//  TabMenuCollectionView.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 22.03.24.
//

import UIKit

final class TabMenuCollectionView: UICollectionView {

    // MARK: - Private Properties
    private var departments = Departments.allCases
    private let departmentLayout = UICollectionViewFlowLayout()
    private var selectedIndexPath: IndexPath?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: departmentLayout)
        configureCollectionView()
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func configureCollectionView() {
        departmentLayout.scrollDirection = .horizontal
        // Автоматическое изменение размера ячейки
        departmentLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.backgroundColor = .white
        self.register(DepartmentCell.self, forCellWithReuseIdentifier: "departmentCell")
        self.showsHorizontalScrollIndicator = false
        selectedIndexPath = IndexPath(item: 0, section: 0)
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TabMenuCollectionView : UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Количество вкладок
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return departments.count
    }
    
    // Настройка ячейки для конкретного индекса
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "departmentCell", for: indexPath) as? DepartmentCell else {
            return DepartmentCell()
        }
        
        let department = departments[indexPath.row]
        cell.configDepartmentCell(with: department)
        
        // Отображение выбранной вкладки
        if selectedIndexPath == indexPath {
            cell.departmentLabel.textColor = UIColor(
                red: 0.02,
                green: 0.02,
                blue: 0.063,
                alpha: 1
            )
            cell.selectedCellView.isHidden = false
        } else {
            // Скрытие выделения
            cell.departmentLabel.textColor = UIColor(
                red: 0.591,
                green: 0.591,
                blue: 0.609,
                alpha: 1
            )
            cell.selectedCellView.isHidden = true
        }
        return cell
    }
    
    // Обработка выбора вкладки
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Снимаем выделение с предыдущей, если есть
        if let previousSelectedIndexPath = selectedIndexPath,
           let previousCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? DepartmentCell {
            previousCell.departmentLabel.textColor = UIColor(
                red: 0.591,
                green: 0.591,
                blue: 0.609,
                alpha: 1
            )
            previousCell.selectedCellView.isHidden = true
        }
        // Установка новой выбранной вкладки
        selectedIndexPath = indexPath
        collectionView.reloadItems(at: [indexPath])
        // Скролл к выбранной ячейке
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}
