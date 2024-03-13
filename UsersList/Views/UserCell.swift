//
//  UserCell.swift
//  UsersList
//
//  Created by Guselnikov Gordey on 13.03.24.
//

import UIKit

class UserCell: UITableViewCell {
    var fullName: String!
    
    override func updateConfiguration(using state: UICellConfigurationState) {
//        var content = self.defaultContentConfiguration().updated(for: state)
        var content = self.defaultContentConfiguration()
        content.text = self.fullName
        
//        if state.isSelected {
//            content.text = "Selected"
//            content.image = UIImage(systemName: "checkmark")
//        }
        
        self.contentConfiguration = content
    }
    
}
