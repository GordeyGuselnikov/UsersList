//
//  User.swift
//  UsersList
//
//  Created by Gordey Guselnikov on 3/9/24.
//

// MARK: - Query
struct Query: Decodable {
    let items: [User]
}

// MARK: - User
struct User: Decodable {
    let id: String
    let avatarUrl: String
    let firstName: String
    let lastName: String
    let userTag: String
    let department: Departments
    let position: String
    let birthday: String
    let phone: String
    
    var fullName: String {
            "\(firstName) \(lastName)"
        }
}

// MARK: - Departments
enum Departments: String, CodingKey, Decodable, CaseIterable {
    case all
    case android
    case iOS = "ios"
    case design
    case management
    case qa
    case backOffice = "back_office"
    case frontend
    case hr
    case pr
    case backend
    case support
    case analytics
    
    var title: String {
        switch self {
        case .all:
            return "Все"
        case .android:
            return "Android"
        case .iOS:
            return "iOS"
        case .design:
            return "Дизайн"
        case .management:
            return "Менеджмент"
        case .qa:
            return "QA"
        case .backOffice:
            return "Бэк-офис"
        case .frontend:
            return "Frontend"
        case .hr:
            return "HR"
        case .pr:
            return "PR"
        case .backend:
            return "Backend"
        case .support:
            return "Техподдержка"
        case .analytics:
            return "Аналитика"
        }
    }
}

