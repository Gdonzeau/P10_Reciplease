//
//  ReceipeListViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit
import CoreData

class RecipeListViewController: ViewController {
    
    var ingredientsUsed = ""
    var parameters: Parameters = .favorites // By défault
    
    @IBOutlet weak var receipesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var deleteDataButton: UIButton!
    @IBAction func deleteData(_ sender: UIButton) {
        deleteObject(rank: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: true)
        
         if parameters == .search {
            deleteDataButton.isHidden = true
         } else {
            deleteDataButton.isHidden = false
         }
         
        if parameters == .search {
            searchForRecipes(ingredients: ingredientsUsed)
        } else {
            loadingFavoriteRecipes()
            receipesTableView.reloadData()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if parameters == .search {
            searchForRecipes(ingredients: ingredientsUsed)
        } else {
            loadingFavoriteRecipes()
            receipesTableView.reloadData()
        }
        receipesTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromCellToChoosenRecipe",
           let recipeChoosenVC = segue.destination as? RecipeChoosenViewController,
           let index = receipesTableView.indexPathForSelectedRow?.row {
            print("C'est parti")
            if parameters == .search {
                recipeChoosenVC.recipeChoosen = RecipeStorage.shared.recipes[index]
            } else {
                recipeChoosenVC.recipeChoosen = FavoriteRecipesStorage.shared.recipes[index]
            }
        }
    }
    
    private func searchForRecipes(ingredients: String) {
        RecipesServices.shared.getRecipes(ingredients: ingredients) { (result) in
            switch result {
            case .success(let recipes) :
                self.toggleActivityIndicator(shown: false)
                guard recipes.recipes.count > 0 else { // There are answers
                    let error = APIErrors.nothingIsWritten
                    if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                        self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                    }
                    return
                }
                //print("Test : \(recipes)")
                self.savingAnswer(recipes:recipes)
                self.receipesTableView.reloadData()
            //self.performSegue(withIdentifier: "segueToReceiptList", sender: nil)
            
            case .failure(let error) :
                print("KO")
                print(error.errorDescription as Any)
            }
        }
    }
    private func savingAnswer(recipes:(RecipeResponse)) { // Converting recipes in an Array before sending it
        
        while RecipeStorage.shared.recipes.count > 0 {
            RecipeStorage.shared.remove(at: 0) // Let's delete the array between two requests
        }
        
        print(recipes.recipes.count)
        for index in 0 ..< recipes.recipes.count {
            // All recipe's characteristics
            // À sortir
            let recipeName = recipes.recipes[index].name
            let image = recipes.recipes[index].imageURL
            let ingredients = recipes.recipes[index].ingredients
            let timeToPrepare = recipes.recipes[index].duration
            let url = recipes.recipes[index].url
            
            let recette = RecipeType(name: recipeName, image: image, ingredientsNeeded: ingredients, totalTime: timeToPrepare, url: url) // Let's finalizing recipe to add to array
            
            RecipeStorage.shared.add(recipe:recette)
            //viewWillAppear(true)
        }
        /*
         for index in 0 ..< RecipeStorage.shared.recipes.count {
         print(RecipeStorage.shared.recipes[index].name)
         }
         */
        //receipesTableView.reloadData()
        
        toggleActivityIndicator(shown: false)
    }
    private func loadingFavoriteRecipes() {
        
        while FavoriteRecipesStorage.shared.recipes.count > 0 {
            FavoriteRecipesStorage.shared.remove(at: 0) // Let's delete the array between two requests
        }
        
        let request: NSFetchRequest<RecipeRegistred> = RecipeRegistred.fetchRequest()
        guard let recipesRegistred = try? AppDelegate.viewContext.fetch(request) else {
            print("erreur, oups.")
            return
        }
        for recipeRegistred in recipesRegistred {
            guard let recipeName = recipeRegistred.name else {
                return
            }
            let image = recipeRegistred.imageUrl
            guard let ingredients = recipeRegistred.ingredients else {
                return
            }
            let timeToPrepare = recipeRegistred.totalTime
            let url = recipeRegistred.url
            
            let recette = RecipeType(name: recipeName, image: image, ingredientsNeeded: ingredients, totalTime: timeToPrepare, url: url) // Let's finalizing recipe to add to array
            
            FavoriteRecipesStorage.shared.add(recipe:recette)
        }
        /*
         for index in 0 ..< FavoriteRecipesStorage.shared.recipes.count {
         print(FavoriteRecipesStorage.shared.recipes[index].name)
         }
         */
        toggleActivityIndicator(shown: false)
    }
    private func deleteObject(rank: Int) {
        let request: NSFetchRequest<RecipeRegistred> = RecipeRegistred.fetchRequest()
        guard let recipesRegistred = try? AppDelegate.viewContext.fetch(request) else {
            return
        }
        let objectToDelete = recipesRegistred[rank]
        AppDelegate.viewContext.delete(objectToDelete)
        /*
        for object in recipesRegistred {
            AppDelegate.viewContext.delete(object)
        }
        */
        do {
            try AppDelegate.viewContext.save()
        }
        catch {
            // Handle Error
        }
        receipesTableView.reloadData()
        
    }
    private func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
        //toggleActivityIndicator(shown: false)
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        receipesTableView.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        print("1")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch parameters {
        case .search:
            print(RecipeStorage.shared.recipes.count)
            return RecipeStorage.shared.recipes.count
        default:
            print(FavoriteRecipesStorage.shared.recipes.count)
            return FavoriteRecipesStorage.shared.recipes.count
        }
        //print(RecipeStorage.shared.recipes.count)
        //return RecipeStorage.shared.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            print("oups")
            return UITableViewCell()
        }
        var recipe = RecipeType(name: "", ingredientsNeeded: [], totalTime: 0.0)
        if parameters == .search {
            recipe = RecipeStorage.shared.recipes[indexPath.row]
        } else {
            recipe = FavoriteRecipesStorage.shared.recipes[indexPath.row]
        }
        let name = recipe.name
        let timeToPrepare = String(Int(recipe.totalTime))
        let image = UIImageView()
        guard let imageUrl = recipe.image else { // There is a picture
            // Create a Default image
            cell.backgroundColor = UIColor.blue
            print("problème d'image")
            return UITableViewCell() // À améliorer...
        }
        guard let URLUnwrapped = URL(string: imageUrl) else {
            print("Lien internet mauvais") // Message d'erreur
            return UITableViewCell() // À améliorer
        }
        image.load(url: URLUnwrapped)
        
        cell.configure(image: image, timeToPrepare: timeToPrepare, imageURL: URLUnwrapped, name: name)
        
        return cell
    }
    
}
extension RecipeListViewController: UITableViewDelegate { // To delete cells one by one
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("On efface : \(indexPath.row)")
            if parameters == .search {
                RecipeStorage.shared.remove(at: indexPath.row)
            } else {
                FavoriteRecipesStorage.shared.recipes[indexPath.row]
                FavoriteRecipesStorage.shared.remove(at: indexPath.row)
                
                do {
                    try AppDelegate.viewContext.save()
                }
                catch {
                    // Handle Error
                }
            }
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
}
