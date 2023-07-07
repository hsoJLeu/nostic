//
//  NetworkService.swift
//  app
//
//  Created by Josh Leung on 10/13/21.
//

import Foundation

class ApiService {
    static let shared = ApiService()
    private let session = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private var errorMessage: Error?
    
    private init() {}
    
    func request<T: Codable>(url: URL, with model: T.Type) async throws -> T? {
        let (data, response) = try await session.data(from: url)
        
        let httpResponse = (response as? HTTPURLResponse)
        let statusCode = httpResponse?.statusCode

        guard statusCode == 200 else {
            print("❗️STATUS: \(String(describing: statusCode))")
            throw NetworkError.badResponse
        }
        guard let response = decodeData(data: data, model: T.self) else {
            throw NetworkError.unableToDecode
        }
        return response
    }
    
    func getData(completion: @escaping(String) ->(Void)) {
        if let urlComponents = URLComponents(string: "") {
            
            guard let url = urlComponents.url else { return }
            
            dataTask = session.dataTask(with: url) { data, response, error in
                defer {
                    self.dataTask = nil
                }
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)" as? Error
                }
                if let data = data,
                   let response = response as? HTTPURLResponse,
                   response.statusCode == 200 {
                    // decode
                    let result = self.decodeData(data: data, model: NotificationsModel.self)
                    completion(String(describing: result))
                }
                
            }
        }
    }
    
    func decodeData<T: Codable>(data: Data, model: T.Type) -> T? {
        let decoded = try? JSONDecoder().decode(model.self, from: data)
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print("Response\(json)")
            
        }
        
        return decoded
    }
    
    enum NetworkError: Error {
        case unableToDecode
        case badResponse
    }
}
