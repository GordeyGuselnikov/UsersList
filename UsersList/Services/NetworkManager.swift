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
    case networkError
    case invalidResponse
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init () {}
    
    func fetchImageData(from urlString: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Загрузка изображения выполняется асинхронно в глобальной очереди
        // Операция загрузки не блокирует основной поток выполнения приложения,
        // что позволяет приложению оставаться отзывчивым во время загрузки.
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            // После успешной загрузки данных переключаемся на основной поток (поток UI)
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
        
    func fetchUser(completion: @escaping(Result<[User], NetworkError>) -> Void) {
        print("Attempting to fetch user data")
        let urlString = "https://stoplight.io/mocks/kode-api/trainee-test/331141861/users"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("code=200, example=success", forHTTPHeaderField: "Prefer")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.networkError))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            print("Status code: \(httpResponse.statusCode)")
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
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
                print("Decoding error: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
}
