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
    var favoriteRecipes = [RecipeType]() // To store recipes from Core Data
    var downloadedRecipes = [RecipeType]() // To store recipes from API
    //var recipesFromCoreData = RecipeRegistred()
    
    @IBOutlet weak var receipesTableView: UITableView!
    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var deleteDataButton: UIButton!
    @IBAction func deleteData(_ sender: UIButton) {
        deleteObject(rank: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleActivityIndicator(shown: true)
        testCoreData() // Only for test
        self.receipesTableView.rowHeight = 120.0
        /*
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
        */
    }
    private func testCoreData() { // Only for test
        for recipe in RecipeRegistred.all {
            print (recipe.name as Any)
        }
    }
    // Nécessaire ?
     override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
        
     if parameters == .search {
     searchForRecipes(ingredients: ingredientsUsed)
     } else {
        print("Youpi")
     //loadingFavoriteRecipes()
        toggleActivityIndicator(shown: false)
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
                //recipeChoosenVC.recipeChoosen = RecipeStorage.shared.recipes[index]
                recipeChoosenVC.recipeChoosen = downloadedRecipes[index]
            } else {
                //recipeChoosenVC.recipeChoosen = FavoriteRecipesStorage.shared.recipes[index]
                recipeChoosenVC.recipeChoosen = convertFromCoreDataToUsable(recipe: RecipeRegistred.all[index])
                //recipeChoosenVC.recipeChoosen = favoriteRecipes[index]
            }
        }
    }
    
    private func searchForRecipes(ingredients: String) { // Receiving recipes from API
        RecipesServices.shared.getRecipes(ingredients: ingredients) { (result) in
            switch result {
            case .success(let recipes) :
                self.toggleActivityIndicator(shown: false)
                guard recipes.recipes.count > 0 else { // There are answers
                    let error = APIErrors.ingredientUnknown // Changer l'erreur pour "Aucune réponse disponible"
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
    private func savingAnswer(recipes:(RecipeResponse)) { // Storing recipes received from API
        
        for index in 0 ..< recipes.recipes.count {
            // All recipe's characteristics
            // À sortir
            let recipeName = recipes.recipes[index].name
            let image = recipes.recipes[index].imageURL
            let ingredients = recipes.recipes[index].ingredients
            let timeToPrepare = recipes.recipes[index].duration
            let url = recipes.recipes[index].url
            let person = Int(recipes.recipes[index].numberOfPeople)
            let recette = RecipeType(name: recipeName, image: image, ingredientsNeeded: ingredients, totalTime: timeToPrepare, url: url, person: person) // Let's finalizing recipe to add to array
            
            downloadedRecipes.append(recette)
        }
        
        toggleActivityIndicator(shown: false)
    }
    private func loadingFavoriteRecipes() { //Storing recipes from CoreData // A retirer et prendre les données depuis CoreData en direct ?
        
    }
    private func deleteObject(rank: Int) {
        let request: NSFetchRequest<RecipeRegistred> = RecipeRegistred.fetchRequest()
        guard let recipesRegistred = try? AppDelegate.viewContext.fetch(request) else {
            return
        }
        
        let objectToDelete = recipesRegistred[rank]
        AppDelegate.viewContext.delete(objectToDelete)
        
        do {
            try AppDelegate.viewContext.save()
        }
        catch {
            // Handle Error
        }
        receipesTableView.reloadData()
        
    }
    private func convertFromCoreDataToUsable(recipe:RecipeRegistred)-> RecipeType {
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
        let recette = RecipeType(name: recipe2Name, image: image, ingredientsNeeded: ingredientList, totalTime: timeToPrepare, url: url, person: person)
        return recette
    }
    private func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
        //toggleActivityIndicator(shown: false)
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        receipesTableView.isHidden = shown
        // activityIndicator.isHidden = !shown
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch parameters {
        case .search:
            return downloadedRecipes.count
        default:
            print("nombre de favoris : \(favoriteRecipes.count)")
            return RecipeRegistred.all.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            print("oups")
            return UITableViewCell()
        }
        var recipe = RecipeType(name: "", ingredientsNeeded: [], totalTime: 0.0, person: 0)
        if parameters == .search {
            recipe = downloadedRecipes[indexPath.row]
        } else {
            recipe = convertFromCoreDataToUsable(recipe: RecipeRegistred.all[indexPath.row])
        }
        
        let name = recipe.name
        var timeToPrepare = ""
        if recipe.totalTime > 0 {
            timeToPrepare = String(Int(recipe.totalTime))
        } else {
            timeToPrepare = "-"
        }
        let image = UIImageView()
        let person = recipe.person
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
        
        //cell.configure(image: image, timeToPrepare: timeToPrepare, imageURL: URLUnwrapped, name: name)
        cell.configure(timeToPrepare: timeToPrepare, name: name, person: person)
        cell.backgroundView = image
        cell.backgroundView?.contentMode = .scaleAspectFill
        //cell.backgroundView?.layer.frame = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 200, height: 130)
        //cell.imageBackgroundCell.init
        
       // cell.
        
        return cell
    }
    
}
extension RecipeListViewController: UITableViewDelegate { // To delete cells one by one
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("On efface : \(indexPath.row)")
            if parameters == .search {
                downloadedRecipes.remove(at: indexPath.row)
                //RecipeStorage.shared.remove(at: indexPath.row)
            } else {
                //FavoriteRecipesStorage.shared.recipes[indexPath.row]
                favoriteRecipes.remove(at: indexPath.row)
                //FavoriteRecipesStorage.shared.remove(at: indexPath.row)
                deleteObject(rank: indexPath.row)
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
