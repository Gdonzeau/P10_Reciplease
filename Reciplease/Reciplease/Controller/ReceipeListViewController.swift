//
//  ReceipeListViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit

class ReceipeListViewController: ViewController {
    var TableViewUSed = ""
    var ingredientsUsed = ""
    var recipesReceived = [RecipeType]()
    //var recipesReceived = [RecipeReceived]()
    @IBOutlet weak var receipesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: true)
        searchForRecipes(ingredients: ingredientsUsed)
        /*
        if recipesReceived.count > 0 {
            let reception = recipesReceived[0].name
            print("reçu : \(reception)")
        }
        */
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        receipesTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromCellToChoosenRecipe",
           let recipeChoosenVC = segue.destination as? RecipeChoosenViewController,
           let index = receipesTableView.indexPathForSelectedRow?.row {
            print("C'est parti")
            recipeChoosenVC.recipeChoosen = recipesReceived[index]
        }
    }
    /*
    private func gettingIngredients() {
        guard IngredientService.shared.ingredients.count > 0 else {
            let error = APIErrors.nothingIsWritten
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
            allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
            return
        }
        for index in 0 ..< IngredientService.shared.ingredients.count {
            ingredientsUsed += IngredientService.shared.ingredients[index].name
            ingredientsUsed += " "
            print(IngredientService.shared.ingredients[index].name)
        }
        /*
        for element in IngredientService.shared.ingredients {
            ingredientsUsed += element.name
        }
 */
    }
 */
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
                //self.performSegue(withIdentifier: "segueToReceiptList", sender: nil)
                
            case .failure(let error) :
                print("KO")
                print(error.errorDescription as Any)
            }
        }
    }
    private func savingAnswer(recipes:(RecipeResponse)) { // Converting recipes in an Array before sending it
        recipesReceived = [RecipeType]() // Let's delete the array between two requests
        print(recipes.recipes.count)
        for index in 0 ..< recipes.recipes.count {
            // All recipe's characteristics
            // À sortir
            let recipeName = recipes.recipes[index].name
            let image = recipes.recipes[index].imageURL
            let ingredients = recipes.recipes[index].ingredients
            let timeToPrepare = recipes.recipes[index].duration
            let url = recipes.recipes[index].url
            guard let imageUrlUnwrapped = URL(string: image) else {
                return // Message d'erreur à ajouter
            }
            guard let UrlRecipe = URL(string: url) else {
                return // Message d'erreur à ajouter
            }
            let recette = RecipeType(name: recipeName, image: image, ingredientsNeeded: ingredients, totalTime: timeToPrepare, url: url) // Let's finalizing recipe to add to array
            
            RecipeStorage.shared.add(recipe:recette)
            viewWillAppear(true)
        }
        toggleActivityIndicator(shown: false)
        for index in 0 ..< RecipeStorage.shared.recipes.count {
            print(RecipeStorage.shared.recipes[index].name)
        }
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
    /*
    func fullingCell(recipe: RecipeType) -> UITableViewCell {
        
        let cell = RecipeTableViewCell()
        let image = UIImageView()
        let timeToPrepare = String(Int(recipe.totalTime))
        let name = recipe.name
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
    */
}

extension ReceipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesReceived.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        let recipe = RecipeStorage.shared.recipes[indexPath.row]
        cell.totalTime.text = String(recipe.totalTime)
        cell.recipeName.text = recipe.name
        //cell.imageBackgroundCell = recipe.image
        //let recipe = recipesReceived[indexPath.row]
        
        //fullingCell(recipe: recipe)
        
        //cell.recipe = recipe //*******
        // Ici il faut changer quelque chose
        /*
        let image = UIImageView()
        let timeToPrepare = String(Int(recipe.totalTime))
        let name = recipe.name
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
        */
        // Fin
        
        // Fin de ce qu'il faut changer
        //cell.textLabel?.text = recipe.name
        
        return cell
    }
    
}

