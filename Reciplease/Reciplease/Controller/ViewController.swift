//
//  ViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 05/07/2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    var recipeFromCoreData = RecipeEntity(context: AppDelegate.viewContext)
    override func viewDidLoad() {
        super.viewDidLoad()
        test2()
        print("Nombre de favoris : \(RecipeEntity.all.count)")
        //recipeFromCoreData.deleteAll()
    }
    
    func test2() {
        //if recipeFromCoreData.loadRecipes().count > 0 {
        if RecipeEntity.all.count > 0 {
            //let recipeEntity = recipeFromCoreData.loadRecipes()[0]
            let recipeEntity = RecipeEntity.all[0]
            let recipe = Recipe(from: recipeEntity)
            print (recipe.name)
        }
    }
 
}

