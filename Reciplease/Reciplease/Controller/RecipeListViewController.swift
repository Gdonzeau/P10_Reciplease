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
    var parameters: Parameters = .favorites // By default
    var favoriteRecipes = [RecipeType]() // To store recipes from Core Data
    var downloadedRecipes = [RecipeType]() // To store recipes from API
    var recipe = Recipe(from: RecipeEntity())
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var receipesTableView: UITableView!
    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isHidden = true
        toggleActivityIndicator(shown: true)
       // testCoreData() // Only for test
        self.receipesTableView.rowHeight = 120.0
        whichImage()
    }
    /*
    private func testCoreData() { // Only for test
        for recipe in RecipeEntity.all {
            print (recipe.name as Any)
        }
    }
 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.isHidden = true
        if parameters == .search {
            searchForRecipes(ingredients: ingredientsUsed)
        } else {
            toggleActivityIndicator(shown: false)
            if RecipeEntity.all.count == 0 {
                //receipesTableView.isHidden = true
                imageView.isHidden = false
            }
            //receipesTableView.reloadData()
        }
        
        receipesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromCellToChoosenRecipe",
           let recipeChoosenVC = segue.destination as? RecipeChoosenViewController,
           let index = receipesTableView.indexPathForSelectedRow?.row {
            if parameters == .search {
                recipeChoosenVC.recipeChoosen = downloadedRecipes[index]
            } else {
                recipeChoosenVC.recipeChoosen = convertFromCoreDataToUsable(recipe: RecipeEntity.all[index])
            }
        }
    }
    private func whichImage() {
        if parameters == .search {
            imageView.image = UIImage(named: "noRecipe")
        } else {
            imageView.image = UIImage(named: "noFavorit")
        }
    }
    private func searchForRecipes(ingredients: String) { // Receiving recipes from API
        RecipesServices.shared.getRecipes(ingredients: ingredients) { (result) in
            switch result {
            case .success(let recipes) :
                self.toggleActivityIndicator(shown: false)
                /* // If no answer, image will appear
                guard recipes.recipes.count > 0 else { // There are answers
                    let error = APIErrors.ingredientUnknown // Changer l'erreur pour "Aucune réponse disponible"
                    if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                        self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                    }
                    return
                }
                */
                self.savingAnswer(recipes:recipes) // self.recipes = recipes
                self.receipesTableView.reloadData()
            
            case .failure(let error) :
                print("KO")
                print(error.errorDescription as Any)
                let error = APIErrors.invalidStatusCode
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            }
        }
    }
    private func savingAnswer(recipes:(RecipeResponse)) { // Storing recipes received from API
        downloadedRecipes = [RecipeType]() // initializing
        for index in 0 ..< recipes.recipes.count {
            // All recipe's characteristics
            // À sortir
            let recipeName = recipes.recipes[index].name
            let image = recipes.recipes[index].imageURL
            let ingredients = recipes.recipes[index].ingredientsNeeded
            let timeToPrepare = recipes.recipes[index].duration
            let url = recipes.recipes[index].url
            let person = Int(recipes.recipes[index].numberOfPeople)
            let recette = RecipeType(name: recipeName, imageUrl: image, ingredientsNeeded: ingredients, duration: timeToPrepare, url: url, numberOfPeople: person) // Let's finalizing recipe to add to array
            
            
            downloadedRecipes.append(recette)
        }
        
        toggleActivityIndicator(shown: false)
    }
    
    private func convertFromCoreDataToUsable(recipe:RecipeEntity)-> RecipeType {
        var recipe2Name = ""
        var ingredientList = [String]()
        if let recipeName = recipe.name {
            recipe2Name = recipeName
        }
        let image = recipe.imageUrl
        if let ingredients = recipe.ingredients {
            ingredientList = ingredients
        }
        let timeToPrepare = recipe.totalTime
        let url = recipe.url
        let person = Int(recipe.person)
        let recette = RecipeType(name: recipe2Name, imageUrl: image, ingredientsNeeded: ingredientList, duration: timeToPrepare, url: url, numberOfPeople: person)
        return recette
    }
    
    private func conversionTry(recipe:RecipeEntity) -> Recipe {
        let recipe = Recipe(from: recipe)
        return recipe
    }
    
    private func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        receipesTableView.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch parameters {
        case .search:
            if downloadedRecipes.count == 0 {
                imageView.isHidden = false
            } else {
                imageView.isHidden = true
            }
            return downloadedRecipes.count
        default:
            //print("nombre de favoris : \(favoriteRecipes.count)/\(RecipeEntity.all.count)")
            if RecipeEntity.all.count == 0 {
                imageView.isHidden = false
            } else {
                imageView.isHidden = true
            }
            return RecipeEntity.all.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        var recipe = RecipeType(name: "", ingredientsNeeded: [], duration: 0.0, numberOfPeople: 0)
        if parameters == .search {
            recipe = downloadedRecipes[indexPath.row]
        } else {
            recipe = convertFromCoreDataToUsable(recipe: RecipeEntity.all[indexPath.row])
        }
        
        let name = recipe.name
        var timeToPrepare = ""
        if recipe.duration > 0 {
            timeToPrepare = String(Int(recipe.duration))
        } else {
            timeToPrepare = "-"
        }
        let image = UIImageView()
        let person = recipe.numberOfPeople
        
        // Mettre des if au lieu des guard pour éviter le return et proposer une alternative par défaut
        guard let imageUrl = recipe.imageUrl else { // There is a picture
            // Create a Default image
            cell.backgroundColor = UIColor.blue
            print("problème d'image")
            return UITableViewCell() // À améliorer...
        }
        guard let URLUnwrapped = URL(string: imageUrl) else {
            let error = APIErrors.noUrl
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
            allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
            print("Lien internet mauvais")
            return UITableViewCell()
        }
        image.load(url: URLUnwrapped)
        cell.configure(timeToPrepare: timeToPrepare, name: name, person: person)
        cell.backgroundView = image
        cell.backgroundView?.contentMode = .scaleAspectFill
        return cell
    }
}
extension RecipeListViewController: UITableViewDelegate { // To delete cells one by one
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("On efface : \(indexPath.row)")
            if parameters == .search {
                downloadedRecipes.remove(at: indexPath.row)
            } else {
                AppDelegate.viewContext.delete(RecipeEntity.all[indexPath.row])
                try? AppDelegate.viewContext.save()
            }
            tableView.deleteRows(at: [indexPath], with: .bottom)
            //viewWillAppear(true)
        }
    }
}
