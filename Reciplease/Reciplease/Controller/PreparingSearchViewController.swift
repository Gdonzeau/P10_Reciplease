//
//  PreparingSearchViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit

class PreparingSearchViewController: ViewController{
    var ingredientsUsed = ""
    var parameters: Parameters = .search
    //var recipesReceived = [RecipeType]()
    
    @IBOutlet weak var ingredientName: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func addIngredientButton(_ sender: UIButton) {
        ingredientName.resignFirstResponder()
        addIngredient()
    }
    @IBAction func searchRecipesButton(_ sender: UIButton) {
        gettingIngredients()
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
            let recipeListVC = segue.destination as! RecipeListViewController
            recipeListVC.ingredientsUsed = ingredientsUsed
            recipeListVC.parameters = parameters
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
        self.performSegue(withIdentifier: "segueToReceiptList", sender: nil)
        /*
        for element in IngredientService.shared.ingredients {
            ingredientsUsed += element.name
        }
 */
    }
    
    private func disMissKeyboardMethod() {
        ingredientName.resignFirstResponder()
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
