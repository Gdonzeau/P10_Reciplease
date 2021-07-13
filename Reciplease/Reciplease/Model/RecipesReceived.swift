//
//  RecipesReceived.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 13/07/2021.
//

import Foundation

struct RecipesReceived {
    var recipes: [Hit]
}
struct HitReceived {
    var recipe: RecipeReceived
}

struct RecipeReceived {
    var named:String
}
