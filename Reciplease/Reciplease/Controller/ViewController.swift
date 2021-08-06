//
//  ViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 05/07/2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    var recipeEntity = RecipeStored(context: AppDelegate.viewContext)
    
    var recipesStored = [RecipeStored]()
    //var recipeFromCoreData = RecipeEntity(context: AppDelegate.viewContext)
    override func viewDidLoad() {
        super.viewDidLoad()
        test2()
        //print("Nombre de favoris : \(RecipeStored.all.count)")
        print("Nombre de favoris : \(recipesStored.count)")
        //recipeFromCoreData.deleteAll()
    }
    
    func test2() {
        //if recipeFromCoreData.loadRecipes().count > 0 {
        if recipesStored.count > 0 { 
        //if RecipeStored.all.count > 0 {
            //let recipeEntity = recipeFromCoreData.loadRecipes()[0]
            //let recipeEntity = RecipeStored.all[0]
            let recipeEntity = recipesStored[0]
            let recipe = Recipe(from: recipeEntity)
            print (recipe.name)
        }
    }
 
}

