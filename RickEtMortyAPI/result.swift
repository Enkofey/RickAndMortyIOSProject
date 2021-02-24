//
//  result.swift
//  RickEtMortyAPI
//
//  Created by Julien DAVID on 27/01/2021.
//

import Foundation

struct Result : Decodable{
    let characters : [SerieCharacter]
    
    enum CodingsKeys : String, CodingKey{
        case characters = "results"
    }
}

struct SerieCharacter : Decodable, Hashable{
    let name: String
    let imageURL: URL
    
    enum CodingKeys : String, CodingKey {
        case name = "name"
        case imageURL = "image"
    }
}
