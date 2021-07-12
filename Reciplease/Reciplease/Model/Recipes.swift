//
//  Recette.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 08/07/2021.
//

import Foundation

struct Recipes: Decodable {
    
    let recipes: [Hit]
    
    enum CodingKeys: String, CodingKey {
        
        case recipes = "hits"
    }
}
struct Hit: Decodable {
    let recipe: Recipe
    
    
    enum CodingKeys: String, CodingKey {
        case recipe
        // case links = "_links"
    }
}

struct Recipe : Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        
        case name = "label"
    }
}
