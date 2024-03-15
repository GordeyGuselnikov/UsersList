//
//  UserCell.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 13.03.24.
//

import UIKit

final class UserCell: UITableViewCell {
    var user: User!
    //    private var additionalLabel: UILabel!
    private let networkManager = NetworkManager.shared
    private let widthImage = 72
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        //        var content = self.defaultContentConfiguration().updated(for: state)
        var content = self.defaultContentConfiguration()
        content.text = user.fullName + " " + user.userTag.lowercased()
        content.secondaryText = user.position
        content.secondaryTextProperties.color = UIColor(red: 0.333, green: 0.333, blue: 0.361, alpha: 1)
        //        content.image = UIImage(systemName: "bicycle")
        content.image = UIImage(named: "goose")
        content.imageProperties.maximumSize = CGSize(width: widthImage, height: widthImage)
        content.imageProperties.cornerRadius = CGFloat(widthImage / 2)
        
        //        if state.isSelected {
        //            content.text = "Selected"
        //            content.image = UIImage(systemName: "checkmark")
        //        }
        networkManager.fetchImageData(from: user.avatarUrl) { [weak self] result in
            
            switch result {
            case .success(let imageData):
                content.image = UIImage(data: imageData)
                self?.contentConfiguration = content
            case .failure(let error):
                print(error)
            }
        }
        
        self.contentConfiguration = content
    }
    
}
