//
//  Recette.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 08/07/2021.
//

import Foundation

struct Recipes: Decodable {
    
    var recipes: [Hit]
    
    enum CodingKeys: String, CodingKey {
        
        case recipes = "hits"
    }
}
struct Hit: Decodable {
    var recipe: Recipe
    
    /*
    enum CodingKeys: String, CodingKey {
        case recipe
        // case links = "_links"
    }
 */
}

struct Recipe : Decodable {
    var named: String
    
    enum CodingKeys: String, CodingKey {
        
        case named = "label"
    }
}
