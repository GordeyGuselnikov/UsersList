//
//  NetworkManager.swift
//  UsersList
//
//  Created by Gordey Guselnikov on 3/9/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init () {}
    
    func fetchImageData(from urlString: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            fatalError("error")
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
        
    func fetchUser(completion: @escaping(Result<[User], NetworkError>) -> Void) {
        print("try to fetch user data")
        let urlString = "https://stoplight.io/mocks/kode-api/trainee-test/331141861/users"
        
        guard let url = URL(string: urlString) else {
            fatalError("error")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("code=200, example=success", forHTTPHeaderField: "Prefer")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, let response else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            print(response)
            
            let httpResponse = response as? HTTPURLResponse
            print("status code: \(httpResponse?.statusCode ?? 0)")
            
            guard httpResponse?.statusCode != 500 else {
                completion(.failure(.serverError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dataModel = try decoder.decode(Query.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataModel.items))
                }
            } catch {
                completion(.failure(.decodingError))
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
}
