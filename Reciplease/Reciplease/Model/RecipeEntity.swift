//
//  RecipeRegistred.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 17/07/2021.
//

import Foundation
import CoreData

class RecipeEntity: NSManagedObject { // Le storage Service
    
    static var all: [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        guard let recipesRegistred = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return recipesRegistred
    }
    
    func loadRecipes() -> [RecipeEntity] {
        var recipesCoreData = [RecipeEntity]()
        for recipe in RecipeEntity.all {
            recipesCoreData.append(recipe)
        }
        return recipesCoreData
    }
    func saveRecipe(recipeToSave: RecipeType) {
        self.imageUrl = recipeToSave.imageUrl
        self.ingredients = recipeToSave.ingredientsNeeded
        self.name = recipeToSave.name
        self.totalTime = recipeToSave.duration
        self.person = Float(Int(recipeToSave.numberOfPeople))
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
