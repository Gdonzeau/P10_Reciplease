//
//  GetRecipes.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 09/07/2021.
//

import Foundation
import Alamofire

class RecipesServices {
    static var shared = RecipesServices()
    private init() {}
    func getRecipes (ingredients: String, completion: @escaping (Result<Recipes,AFError>)->Void) { //completio type result
        //let adressUrl = "https://api.edamam.com/api/recipes/v2?type=public"
        let adressUrl = Settings.urlAdress // A mettre dans un fichier config
        
        let parameters = ["app_id": Keys.id.rawValue,
                          "app_key":Keys.key.rawValue,
                          "q": ingredients]
        Session.default.request(adressUrl, parameters: parameters)
            .validate() //requête et valide que la réponse est valide (200, pas d'erreur, etc.)
            .responseDecodable(of: Recipes.self) { (response) in
                completion(response.result)
            }
    }
}
