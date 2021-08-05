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
     
    func loadRecipes() -> [RecipeEntity] { // Ajouter throws
        
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        
        do {
            print("Ok")
            let response = try AppDelegate.viewContext.fetch(request) // response = total des données du CoreData
            return response
        } catch {
            let error = APIErrors.noData // Peut-être pas API... mais juste Error
            print(error)
            //return error
            return [RecipeEntity]()
        }
        
    }
    func saveRecipe(recipeToSave: Recipe) {
        self.imageUrl = recipeToSave.imageURL
        self.ingredients = recipeToSave.ingredientsNeeded
        self.name = recipeToSave.name
        self.totalTime = recipeToSave.duration
        self.person = Float(Int(recipeToSave.numberOfPeople))
        self.url = recipeToSave.url
        
        try? AppDelegate.viewContext.save()
    }
    func deleteRecipe(recipeToDelete: Recipe) {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let response = try AppDelegate.viewContext.fetch(request)
        } catch {
            print("Error while deleting")
            return
        }
        let recipe  = RecipeEntity(context: AppDelegate.viewContext)
        
        recipe.imageUrl = recipeToDelete.imageURL
        recipe.ingredients = recipeToDelete.ingredientsNeeded
        recipe.name = recipeToDelete.name
        recipe.totalTime = recipeToDelete.duration
        recipe.person = Float(Int(recipeToDelete.numberOfPeople))
        recipe.url = recipeToDelete.url
        
        AppDelegate.viewContext.delete(recipe)
    }
    func deleteAll() {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let response = try AppDelegate.viewContext.fetch(request)
            
            for recipe in response {
                AppDelegate.viewContext.delete(recipe)
            }
            try? AppDelegate.viewContext.save()
            
        } catch {
            print("Error while deleting")
            return
        }
        
    }
}
/*
 
 init(persistentContainer: (UIApplication.shared.delegate as! AppDelegate).persistentContainer
 ViewContext = persistentContainer de ViewContext
 
 LoadRecipes -> tableau de recettes
 SaveRecipes
 DeleteRecipe
 
 
 */
