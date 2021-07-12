//
//  PreparingSearchViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit

class PreparingSearchViewController: ViewController{
    var ingredientsUsed = ""
    //var recipesSended = Recipes?.self
    var recipesSended = "Bonjour"
    @IBOutlet weak var ingredientName: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    
    @IBAction func addIngredientButton(_ sender: UIButton) {
        ingredientName.resignFirstResponder()
        addIngredient()
    }
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        gettingIngredients()
        searchForRecipes(ingredients: ingredientsUsed)
        performSegue(withIdentifier: "segueToReceiptList", sender: nil)
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        disMissKeyboardMethod()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToReceiptList" {
            let successVC = segue.destination as! ReceipeListViewController
            successVC.recipesSended = recipesSended
        }
    }
    func addIngredient() {
        guard let ingredientAdded = ingredientName.text else {
            return
        }
        
        let newIngredient = Ingredient(name: ingredientAdded)
        IngredientService.shared.add(ingredient: newIngredient)
        ingredientName.text = ""
        viewWillAppear(true)
    }
    func gettingIngredients() {
        
        for index in 0 ..< IngredientService.shared.ingredients.count {
            ingredientsUsed += IngredientService.shared.ingredients[index].name
            ingredientsUsed += " "
        }
        /*
        for element in IngredientService.shared.ingredients {
            ingredientsUsed += element.name
        }
 */
    }
    
    func disMissKeyboardMethod() {
        ingredientName.resignFirstResponder()
    }
    func searchForRecipes(ingredients: String) {
        RecipesServices.shared.getRecipes(ingredients: ingredients) { (result) in // Attention, ingrédient mal écrit provoque fatalError
            switch result {
            case .success(let recipes) :
                print("Ok")
                //recipesSended = recipes
                print(recipes.recipes[0].recipe.name)
            case .failure(let error) :
                print("KO")
                print(error.errorDescription as Any)
            }
        }
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
extension PreparingSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientName.resignFirstResponder()
        ingredientName.text = ""
        return true
    }
}
