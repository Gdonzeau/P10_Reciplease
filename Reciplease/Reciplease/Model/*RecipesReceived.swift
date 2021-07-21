//
//  RecipesReceived.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 13/07/2021.
//

import Foundation
/*
struct RecipesReceived {
    var recipesReceived:[Recette]
}
*/
/*
 "hits": [
         {
             "recipe": {
                 "uri": "http://www.edamam.com/ontologies/edamam.owl#recipe_f285a9024489ce7a34573a6a83fe5c17",
                 "label": "Herbed Chicken & Tomatoes recipes",
                 "image": "https://www.edamam.com/web-img/7aa/7aa9a0006423f523e3064b055d4a09e0",
                 "source": "Epicurious",
                 "url": "http://www.epicurious.com/recipes/food/views/herbed-chicken-tomatoes-56390044",
                 "shareAs": "http://www.edamam.com/recipe/herbed-chicken-tomatoes-recipes-f285a9024489ce7a34573a6a83fe5c17/chicken+tomatoes",
                 
                 "ingredientLines": [
                     "8 ounces pasta, such as spaghetti or linguine",
                     "1 1/2 teaspoons McCormick Gourmet™ Basil",
                     "1 1/2 teaspoons McCormick Gourmet™ Garlic Powder, California",
                     "1 teaspoon McCormick Gourmet™ Rosemary, Crushed",
                     "3 tablespoons flour, divided",
                     "1 1/2 pounds thin-sliced boneless skinless chicken breasts",
                     "2 to 3 tablespoons vegetable oil, divided",
                     "1 small onion, finely chopped",
                     "1 can (14 1/2 ounces) petite diced tomatoes, drained",
                     "1 1/2 cups Kitchen Basics® Unsalted Chicken Stock",
                     "2 tablespoons fat free half-and-half"
                 ],
                 "ingredients": [
                     {
 */

struct RecipeReceived: Codable {
    var recipe: [Recipe]
    var name: String // label selon l'API
    var image: URL?
    var ingredientsNeeded: [String]
    var totalTime: Float
    var url: URL?
    
    enum CodingKeys: String, CodingKey {
        // Premier niveau hits (tableau de recipes)
        case recipe
    }
    enum RecipeKeys: String, CodingKey {
        case name = "label"
        case image
        case ingredientsNeeded = "indredientLines"
        case totalTime
        case url
        //case additionnalInfo
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys)
        try container.encode(<#T##value: Bool##Bool#>, forKey: <#T##KeyedEncodingContainer<CodingKeys>.Key#>)
    }
}
/*
extension RecipeReceived: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .additionnalInfo)
    }
}
*/
