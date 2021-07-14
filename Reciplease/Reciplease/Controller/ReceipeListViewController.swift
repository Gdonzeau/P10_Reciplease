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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromCellToChoosenRecipe",
           let recipeChoosenVC = segue.destination as? RecipeChoosenViewController,
           let index = receipesTableView.indexPathForSelectedRow?.row {
            print("C'est parti")
            //let recipeChoosenVC = segue.destination as! RecipeChoosenViewController
            //let blogIndex = tableView.indexPathForSelectedRow?.row
            recipeChoosenVC.recipeName = recipesReceived[index].name
            
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
        let imageURL = recipesReceived[indexPath.row].image
        cell.textLabel?.text = recipe.name
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let row = indexPath.row
            print(row)
        }
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            //getting the index path of selected row
            let indexPath = tableView.indexPathForSelectedRow
        print(indexPath as Any)
            //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
            print(currentCell)
            //getting the text of that cell
            let currentItem = currentCell.textLabel!.text
            
        let alertController = UIAlertController(title: "Simplified iOS", message: "You Selected " + currentItem! , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
        present(alertController, animated: true, completion: nil)
        }
    */
    
}
 
