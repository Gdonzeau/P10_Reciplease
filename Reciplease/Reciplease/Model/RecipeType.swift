//
//  Recettes.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 08/07/2021.
//

import Foundation

struct RecipeType {
    var name: String
    var image: String?//URL?
    var ingredientsNeeded: [String]
    var totalTime: Float
    var url: String?//URL?
  }

extension RecipeType: Equatable {
    static func == (lhs: RecipeType, rhs: RecipeType) -> Bool {
        return lhs.name == rhs.name && lhs.url == rhs.url // if var(de type Recipe) == var(
    }
}

