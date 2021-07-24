//
//  FavoriteRecipeListViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 24/07/2021.
//

import UIKit
import CoreData

class FavoriteRecipeListViewController: UIViewController {
    
    var TableViewUSed = ""
    var recipesReceived = [RecipeType]()
    var recipes = RecipeRegistred.all
    //var recipesReceived = RecipeRegistred.all
    //var recipesReceived = [RecipeReceived]()
    @IBOutlet weak var receipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request: NSFetchRequest<RecipeRegistred> = RecipeRegistred.fetchRequest()
        guard let recipesRegistred = try? AppDelegate.viewContext.fetch(request) else {
            print("erreur, oups.")
            return
        }
        //print("Voilà")
        //print(recipesRegistred[0].name)
        for recipeRegistred in recipesRegistred {
            if let name = recipeRegistred.name, let ingredientsNeeded = recipeRegistred.ingredients {
                let totalTime = recipeRegistred.totalTime
                let recipe = RecipeType(name: name, ingredientsNeeded: ingredientsNeeded, totalTime: totalTime)
                //print(recipe.name)
                recipesReceived.append(recipe)
            }
        }
        print("recettes enregistrées")
        for index in 0 ..< recipesRegistred.count {
            guard let recetteLue = recipesRegistred[index].name else {
                return
            }
            print(recetteLue)
        }
        
        
        
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
        print("Va apparaître")
        //recipes = recipesReceived
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromCellToChoosenRecipe",
           let recipeChoosenVC = segue.destination as? RecipeChoosenViewController,
           let index = receipesTableView.indexPathForSelectedRow?.row {
            print("C'est parti")
            recipeChoosenVC.recipeChoosen = recipesReceived[index]
        }
    }
}

extension FavoriteRecipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return recipesReceived.count
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        let recipe = recipesReceived[indexPath.row]
        //cell.recipe = recipe //*******
        // Ici il faut changer quelque chose
        let image = UIImageView()
        let timeToPrepare = String(Int(recipe.totalTime))
        let name = recipe.name
        guard let imageUrl = recipe.image else { // There is a picture
            // Create a Default image
            cell.backgroundColor = UIColor.darkGray
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


