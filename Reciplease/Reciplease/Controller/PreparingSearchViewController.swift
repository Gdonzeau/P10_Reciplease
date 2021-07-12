//
//  PreparingSearchViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit

class PreparingSearchViewController: ViewController {

    @IBAction func searchRecipesButton(_ sender: UIButton) {
        searchForRecipes()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func searchForRecipes() {
        RecipesServices.shared.getRecipes(ingredients: "Chicken,Tomatoes,Chocolate") { (result) in // Attention, ingrédient mal écrit provoque fatalError
            switch result {
            case .success(let recipes) :
                print("Ok")
                print(recipes.recipes[0].recipe.name)
            case .failure(let error) :
                print("KO")
                print(error.errorDescription as Any)
            }
        }
    }
}
