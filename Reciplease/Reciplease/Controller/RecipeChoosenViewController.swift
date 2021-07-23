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
    var recipeChoosen = RecipeType(name: "", image: URL(string: ""), ingredientsNeeded: [], totalTime: 0.00, url: URL(string: ""))
    //var imageUrl = URL(string: "")
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsList: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        toggleActivityIndicator(shown: true)
        
        if let url = recipeChoosen.url {
            UIApplication.shared.open(url)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        prepareInformations()
        blogNameLabel.text = recipeName
        ingredientsList.text = ingredientList
        guard let imageUrl = recipeChoosen.image else {
            return
        }
        imageRecipe.load(url: imageUrl)
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
    private func toggleActivityIndicator(shown: Bool) {
        getDirectionsButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    private func addRecipeToFavorites() {
        saveRecipe(recipeToSave: recipeChoosen)
    }
    
    private func saveRecipe(recipeToSave: RecipeType) {
        let recipe = RecipeRegistred(context: AppDelegate.viewContext) //Appel du CoreDate RecipeService
        //recipe.imageUrl = recipeToSave.image
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
