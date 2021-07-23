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
        //cell.recipe = recipe //*******
        // Ici il faut changer quelque chose
        let image = UIImageView()
        let timeToPrepare = String(Int(recipe.totalTime))
        let name = recipe.name
        if let imageUrl = recipe.image { // There is a picture
            image.load(url: imageUrl)
            cell.configure(image: image, timeToPrepare: timeToPrepare, imageURL: imageUrl, name: name)
            // Fin
        } else { // Create a Default image
            cell.backgroundColor = UIColor.darkGray
            print("problème d'image")
        }
        // Fin de ce qu'il faut changer
        //cell.textLabel?.text = recipe.name
        return cell
    }
    
}
 
