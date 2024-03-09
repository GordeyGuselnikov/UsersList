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


struct User: Decodable {
    let id: String
    let avatarUrl: String
    let firstName: String
    let lastName: String
    let userTag: String
//    let department: Departments
    let position: String
    let birthday: String
    let phone: String
}

//enum Departments: String {
//    
//}
