//
//  PreparingSearchViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit

class PreparingSearchViewController: ViewController{
    var ingredientsUsed = ""
    //var recipesReceived = [RecipeReceived]()
    var recipesReceived = [RecipeType]()
    
    @IBOutlet weak var ingredientName: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func addIngredientButton(_ sender: UIButton) {
        ingredientName.resignFirstResponder()
        addIngredient()
    }
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        toggleActivityIndicator(shown: true)
        gettingIngredients()
        searchForRecipes(ingredients: ingredientsUsed)
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        disMissKeyboardMethod()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToReceiptList" {
            let receipListVC = segue.destination as! ReceipeListViewController
            //receipListVC.recipesSended = recipesSended
            receipListVC.recipesReceived = recipesReceived
        }
    }
    private func addIngredient() {
        guard var ingredientAdded = ingredientName.text else {
            return
        }
        ingredientAdded = "- " + ingredientAdded
        
        let newIngredient = Ingredient(name: ingredientAdded)
        IngredientService.shared.add(ingredient: newIngredient)
        ingredientName.text = ""
        viewWillAppear(true)
    }
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
    
    private func disMissKeyboardMethod() {
        ingredientName.resignFirstResponder()
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
                self.performSegue(withIdentifier: "segueToReceiptList", sender: nil)
                
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
            
            recipesReceived.append(recette)
        }
    }
    private func toggleActivityIndicator(shown: Bool) {
        searchButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    private func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
        //toggleActivityIndicator(shown: false)
    }
}

extension PreparingSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngredientService.shared.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        
        let ingredient = IngredientService.shared.ingredients[indexPath.row]
        
        cell.textLabel?.text = ingredient.name
        
        return cell
    }
}
extension PreparingSearchViewController: UITextFieldDelegate { // To dismiss keyboard when returnKey
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientName.resignFirstResponder()
        ingredientName.text = ""
        return true
    }
}
extension PreparingSearchViewController: UITableViewDelegate { // To delete cells one by one
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("On efface : \(indexPath.row)")
            IngredientService.shared.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
}
