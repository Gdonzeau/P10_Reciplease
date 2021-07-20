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
}
/*
 
 init(persistentContainer: (UIApplication.shared.delegate as! AppDelegate).persistentContainer
ViewContext = persistentContainer de ViewContext
 
 LoadRecipes -> tableau de recettes
 SaveRecipes
 DeleteRecipe
 
 
 */
