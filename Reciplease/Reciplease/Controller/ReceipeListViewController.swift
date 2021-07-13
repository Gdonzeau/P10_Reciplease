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
    
    @IBOutlet weak var receipesTableView: UITableView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let reception = recipesReceived[0].name
        print("reçu : \(reception)")
        // Do any additional setup after loading the view.
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
        let imageURL = recipesReceived[indexPath.row].image
        cell.textLabel?.text = recipe.name
        
        
        return cell
    }
    
    
}
 
