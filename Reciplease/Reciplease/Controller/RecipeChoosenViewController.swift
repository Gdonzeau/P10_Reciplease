//
//  RecipeChoosenViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit

class RecipeChoosenViewController: UIViewController {

    var recipeName = String()
    var ingredientList = String()
    var recipeChoosen = RecipeType(name: "", image: "", ingredientsNeeded: [], totalTime: 0.00, url: "")
    //var imageUrl = URL(string: "")
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsList: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func saveRecipe(_ sender: UIButton) {
        addRecipeToFavorites()
    }
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        if let url = recipeChoosen.url {
            guard let urlAdress = URL(string: url) else {
                return
            }
            UIApplication.shared.open(urlAdress)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        prepareInformations()
        blogNameLabel.text = recipeName
        ingredientsList.text = ingredientList
        guard let imageUrl = recipeChoosen.image else {
            return // Message d'erreur à ajouter
        }
        guard let imageUrlUnwrapped = URL(string: imageUrl) else {
            return // Message d'erreur à ajouter
        }
        imageRecipe.load(url: imageUrlUnwrapped)
    }
    private func prepareInformations() {
        recipeName = recipeChoosen.name
        presentIngredients()
    }
    private func presentIngredients() {
        for index in 0 ..< recipeChoosen.ingredientsNeeded.count {
            ingredientList += "- "
            ingredientList += recipeChoosen.ingredientsNeeded[index]
            ingredientList += "\n"
        }
    }
    
    private func addRecipeToFavorites() {
        saveRecipe(recipeToSave: recipeChoosen)
    }
    
    private func saveRecipe(recipeToSave: RecipeType) {
        let recipe = RecipeRegistred(context: AppDelegate.viewContext) //Appel du CoreDate RecipeService
        recipe.imageUrl = recipeToSave.image
        recipe.ingredients = recipeToSave.ingredientsNeeded
        recipe.name = recipeToSave.name
        recipe.totalTime = recipeToSave.totalTime
        
        try? AppDelegate.viewContext.save()
    }
    
    
}
extension UIImageView { // Publishing the image
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            guard let image = UIImage(data:data) else {
                return
            }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
