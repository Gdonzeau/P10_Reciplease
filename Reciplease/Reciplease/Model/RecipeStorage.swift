//
//  RecipeService.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 25/07/2021.
//

import Foundation
class RecipeStorage {
    static let shared = RecipeStorage()
    private init() {}

    private(set) var recipes: [RecipeType] = []

    func add(recipe: RecipeType) {
        recipes.append(recipe)
    }
    func remove(at index: Int) {
        recipes.remove(at: index)
    }
}
