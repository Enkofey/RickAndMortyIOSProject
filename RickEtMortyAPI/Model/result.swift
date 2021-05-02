//
//  result.swift
//  RickEtMortyAPI
//
//  Created by Julien DAVID on 27/01/2021.
//

import Foundation

struct Result : Decodable{
    let results : [SerieCharacter]
    
    enum CodingsKeys : String, CodingKey{
        case results = "results"
    }
}

struct SerieCharacter : Decodable, Hashable{
    let name: String
    let imageURL: URL
    let status: String
    
    func contains(query: String?) -> Bool {
            guard let query = query else { return true }
            guard !query.isEmpty else { return true }
            let lowerCasedQuery = query.lowercased()
            return name.lowercased().contains(lowerCasedQuery)
        }
    
    enum CodingKeys : String, CodingKey {
        case name = "name"
        case imageURL = "image"
        case status = "status"
    }
}
