//
//  ServiceManager.swift
//  CoreDataOtusDZ
//
//  Created by Вячеслав Вовк on 13.02.2025.
//

import Foundation

class ServiceManager {
    private let baseURL = "https://rickandmortyapi.com/api/character"
    
    func fetchDataFromAPI(next: String?) async throws -> ResponseModel {
        var needUrl: URL
        guard let url = URL(string: baseURL) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        needUrl = url
        if let next, let nextURL = URL(string: next) {
            needUrl = nextURL
            
        }
        let (data, _) = try await URLSession.shared.data(from: needUrl)
      
        // Десериализуем ответ
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(ResponseModel.self, from: data)
            return result
        }catch {
            throw error
        }
        
    }
    
    func fetchImage(for imageString: String) async throws -> Data {
        guard let imageURL = URL(string: imageString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        let (data, _) = try await URLSession.shared.data(from: imageURL)
        return data
    }
}
