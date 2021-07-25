//
//  ReceipeListViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit

class ReceipeListViewController: ViewController {
    var TableViewUSed = ""
    var recipesReceived = [RecipeType]()
    //var recipesReceived = [RecipeReceived]()
    @IBOutlet weak var receipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if recipesReceived.count > 0 {
            let reception = recipesReceived[0].name
            print("reçu : \(reception)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromCellToChoosenRecipe",
           let recipeChoosenVC = segue.destination as? RecipeChoosenViewController,
           let index = receipesTableView.indexPathForSelectedRow?.row {
            print("C'est parti")
            recipeChoosenVC.recipeChoosen = recipesReceived[index]
        }
    }
    
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
        let recipe = recipesReceived[indexPath.row]
        //fullingCell(recipe: recipe)
        
        //cell.recipe = recipe //*******
        // Ici il faut changer quelque chose
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
        // Fin
        
        // Fin de ce qu'il faut changer
        //cell.textLabel?.text = recipe.name
        
        return cell
    }
    
}

