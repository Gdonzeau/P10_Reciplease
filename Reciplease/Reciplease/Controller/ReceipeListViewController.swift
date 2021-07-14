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
    var recipesReceived = [Recette]()
    //var recipeChoosen  = Recette(name: "", image: URL(string: "")!, ingredientsNeeded: [])
    
    @IBOutlet weak var receipesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let reception = recipesReceived[0].name
        print("reçu : \(reception)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromCellToChoosenRecipe",
           let recipeChoosenVC = segue.destination as? RecipeChoosenViewController,
           let index = receipesTableView.indexPathForSelectedRow?.row {
            print("C'est parti")
            //let recipeChoosenVC = segue.destination as! RecipeChoosenViewController
            //let blogIndex = tableView.indexPathForSelectedRow?.row
            recipeChoosenVC.recipeName = recipesReceived[index].name
            recipeChoosenVC.recipeChoosen = recipesReceived[index]
            recipeChoosenVC.imageUrl = recipesReceived[index].image
        }
    }
}

extension ReceipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Données à changer. Ici, juste pour faire tourner le prgm
        return recipesReceived.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        let recipe = recipesReceived[indexPath.row]
        //let imageURL = recipesReceived[indexPath.row].image
        cell.textLabel?.text = recipe.name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let row = indexPath.row
            print(row)
        }
}
 
