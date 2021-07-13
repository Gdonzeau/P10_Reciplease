//
//  ReceipeListViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit

class ReceipeListViewController: ViewController {
    //var recipesSended = Recipes?.self
    var recipesSended = ""
    var recipesReceived: RecipesReceived!
    @IBOutlet weak var receipesTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let reception = recipesSended
        let reception = recipesReceived
        print("reçu : \(String(describing: reception))")
        // Do any additional setup after loading the view.
    }
    
}

extension ReceipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Données à changer. Ici, juste pour faire tourner le prgm
        return IngredientService.shared.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        
        let ingredient = IngredientService.shared.ingredients[indexPath.row]
        
        cell.textLabel?.text = ingredient.name
        
        return cell
    }
    
    
}
 
