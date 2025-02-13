//
//  ResponseModel.swift
//  CoreDataOtusDZ
//
//  Created by Вячеслав Вовк on 13.02.2025.
//


import Foundation


// MARK: - ResponseModel
struct ResponseModel: Codable {
    let info: Info
    let results: [CharacrterModel]
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int
    let next: String
    let prev: String?
}

// MARK: - CharacrterModel
struct CharacrterModel: Codable, Identifiable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}

enum Species: String, Codable {
    case alien = "Alien"
    case human = "Human"
    case humanoid = "Humanoid"
    case unknown
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
