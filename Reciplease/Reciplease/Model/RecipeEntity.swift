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
         
        
        /*
        var recipesCoreData = [RecipeEntity]()
        for recipe in RecipeEntity.all {
            recipesCoreData.append(recipe)
        }
        return recipesCoreData
        */
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
