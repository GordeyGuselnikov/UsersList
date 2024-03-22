//
//  SortSheetController.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 18.03.24.
//

import UIKit

enum SortType: String {
    case alphabet = "По алфавиту"
    case birthday = "По дню рождения"
}

final class SortSheetController: UIViewController {

    // MARK: - Private Properties
    private let sortAlphabeticallyRadioView = RadioButtonView()
    private let sortByBirthdayRadioView = RadioButtonView()
    private var radioButtonView = RadioButtonView()
    
    var selectedSortType: SortType?
    
    weak var sortDelegate: SortSheetControllerDelegate?
    
    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        backButtonSetup()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = .white
        title = "Сортировка"
        configNavigationBar()
        configRadioButtonView(with: .alphabet)
        configRadioButtonView(with: .birthday)
        
        // Констрейнты для sortAlphabeticallyRadioView
        sortAlphabeticallyRadioView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortAlphabeticallyRadioView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            sortAlphabeticallyRadioView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            sortAlphabeticallyRadioView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            sortAlphabeticallyRadioView.heightAnchor.constraint(equalToConstant: 60)
        ])

        // Констрейнты для sortByBirthdayRadioView
        sortByBirthdayRadioView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortByBirthdayRadioView.topAnchor.constraint(equalTo: sortAlphabeticallyRadioView.bottomAnchor),
            sortByBirthdayRadioView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            sortByBirthdayRadioView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            sortByBirthdayRadioView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        
    }
    
    private func configNavigationBar() {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Inter-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20.0, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func backButtonSetup() {
        let backButton = UIBarButtonItem(image: UIImage(named: "Arrow"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(dismissViewController))
        backButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configRadioButtonView(with sortType: SortType) {
        
        switch sortType {
        case .alphabet:
            radioButtonView = sortAlphabeticallyRadioView
            sortAlphabeticallyRadioView.radioButton.isSelected = sortType == selectedSortType
            
        case .birthday:
            radioButtonView = sortByBirthdayRadioView
            sortByBirthdayRadioView.radioButton.isSelected = sortType == selectedSortType
        }
        
        sortAlphabeticallyRadioView.radioButton.addTarget(
            self,
            action: #selector(sortAlphabeticallyRadioButtonTapped),
            for: .touchUpInside
        )
        sortByBirthdayRadioView.radioButton.addTarget(
            self,
            action: #selector(sortByBirthdayRadioButtonTapped),
            for: .touchUpInside
        )
        
        view.addSubview(radioButtonView)
        radioButtonView.sortNameLabel.text = sortType.rawValue
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc private func sortAlphabeticallyRadioButtonTapped(_ sender: UIButton) {
        sender.isSelected = true
        sortByBirthdayRadioView.radioButton.isSelected = false
        sortDelegate?.setSort(sortType: .alphabet)
        dismissViewController() // по функциональным требованиям: При переключении варианта сортировки Bottom Sheet закрывается
    }
    
    @objc private func sortByBirthdayRadioButtonTapped(_ sender: UIButton) {
        sender.isSelected = true
        sortAlphabeticallyRadioView.radioButton.isSelected = false
        sortDelegate?.setSort(sortType: .birthday)
        dismissViewController() // по функциональным требованиям: При переключении варианта сортировки Bottom Sheet закрывается
    }
    
}
