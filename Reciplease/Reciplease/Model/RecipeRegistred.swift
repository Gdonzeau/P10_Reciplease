//
//  RecipeRegistred.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 17/07/2021.
//

import Foundation
import CoreData

class RecipeRegistred: NSManagedObject {
    
    static var all: [RecipeRegistred] {
        let request: NSFetchRequest<RecipeRegistred> = RecipeRegistred.fetchRequest()
        guard let recipesRegistred = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return recipesRegistred
    }
    
    func loadRecipes() -> [RecipeRegistred] {
        var recipesCoreData = [RecipeRegistred]()
        for recipe in RecipeRegistred.all {
            recipesCoreData.append(recipe)
        }
        return recipesCoreData
    }
    func saveRecipe(recipeToSave: RecipeType) {
        self.imageUrl = recipeToSave.image
        self.ingredients = recipeToSave.ingredientsNeeded
        self.name = recipeToSave.name
        self.totalTime = recipeToSave.totalTime
        self.person = Float(Int(recipeToSave.person))
        self.url = recipeToSave.url
        
        try? AppDelegate.viewContext.save()
    }
    func deleteRecipe() {
        
    }
}
/*
 
 init(persistentContainer: (UIApplication.shared.delegate as! AppDelegate).persistentContainer
ViewContext = persistentContainer de ViewContext
 
 LoadRecipes -> tableau de recettes
 SaveRecipes
 DeleteRecipe
 
 
 */
