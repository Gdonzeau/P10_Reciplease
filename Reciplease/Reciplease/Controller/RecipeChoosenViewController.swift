//
//  RecipeChoosenViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit
import CoreData

class RecipeChoosenViewController: UIViewController {
    
    var recipeName = String()
    var ingredientList = String()
    var recipeChoosen = RecipeType(name: "", image: "", ingredientsNeeded: [], totalTime: 0.00, url: "", person: 0)
    //var recetteChoisie = Recipe(from: <#Decoder#>)
    //var imageUrl = URL(string: "")
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsList: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var saveRecipeButton: UIButton!
    @IBOutlet weak var deleteRecipeButton: UIButton!
    
    @IBAction func saveRecipe(_ sender: UIButton) {
        //addRecipeToFavorites()
        print("On ajoute \(recipeChoosen)")
        buttonAddIs(visible: false)
        if isRecipeNotAlreadyRegistred() == true { // Not necessary as button Save won't be visible...
            savingRecipe(recipeToSave: recipeChoosen)
        }
        //addRecipeToFavorites()
    }
    @IBAction func deleteRecipe(_ sender: UIButton) {
        buttonAddIs(visible: true)
        let request: NSFetchRequest<RecipeRegistred> = RecipeRegistred.fetchRequest()
        guard let recipesRegistred = try? AppDelegate.viewContext.fetch(request) else {
            return
        }
        for index in 0 ..< recipesRegistred.count {
            let object = recipesRegistred[index]
            guard let name = object.name, let ingredients = object.ingredients else {
                return
            }
            let url = object.url
            let image = object.imageUrl
            let totalTime = object.totalTime
            let person = Int(object.person)
            let recipe = RecipeType(name: name, image: image, ingredientsNeeded: ingredients, totalTime: totalTime, url: url, person: person)
            if recipe == recipeChoosen {
                // Effacer la recette
                let objectToDelete = recipesRegistred[index]
                AppDelegate.viewContext.delete(objectToDelete)
                print("Trouvé, on efface")
                //deleteRecipeFromCoreData(recipeToDelete: recipeChoosen)
                return
            } else {
                print("Absent de la base de données") // Théoriquement n'arrivera pas
                return
            }
        }
    }
    
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        if let url = recipeChoosen.url {
            guard let urlAdress = URL(string: url) else {
                return
            }
            UIApplication.shared.open(urlAdress)
        } else {
            print("no url")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        testCoreData()
        buttonAddIs(visible: isRecipeNotAlreadyRegistred())
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
    private func testCoreData() { // Only for test
        for recipe in RecipeRegistred.all {
            print (recipe.name as Any)
        }
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
    /*
     private func addRecipeToFavorites() {
     saveRecipe(recipeToSave: recipeChoosen)
     }
     */
    private func isRecipeNotAlreadyRegistred()-> Bool {
        if RecipeRegistred.all.count == 0 {
            return true
        }
        for object in RecipeRegistred.all {
            guard let name = object.name, let ingredients = object.ingredients else {
                return false // A modifier
            }
            let url = object.url
            let image = object.imageUrl
            let totalTime = object.totalTime
            let person = Int(object.person)
            let recipe = RecipeType(name: name, image: image, ingredientsNeeded: ingredients, totalTime: totalTime, url: url, person: person)
            
            if recipe == recipeChoosen { // is the recipe on the View already favorit ?
                return false
            }
        }
        return true
    }
    private func savingRecipe(recipeToSave: RecipeType) {
        let recipe = RecipeRegistred(context: AppDelegate.viewContext) //Appel du CoreDate RecipeService
        recipe.saveRecipe(recipeToSave: recipeToSave)
        /*
        recipe.imageUrl = recipeToSave.image
        recipe.ingredients = recipeToSave.ingredientsNeeded
        recipe.name = recipeToSave.name
        recipe.totalTime = recipeToSave.totalTime
        recipe.person = Float(Int(recipeToSave.person))
        recipe.url = recipeToSave.url
        
        try? AppDelegate.viewContext.save()
        */
    }
    /*
     private func deleteRecipeFromCoreData(recipeToDelete: RecipeType) {
     let recipe = RecipeRegistred(context: AppDelegate.viewContext) //Appel du CoreDate RecipeService
     recipe.imageUrl = recipeToDelete.image
     recipe.ingredients = recipeToDelete.ingredientsNeeded
     recipe.name = recipeToDelete.name
     recipe.totalTime = recipeToDelete.totalTime
     AppDelegate.viewContext.delete(recipe)
     try? AppDelegate.viewContext.save()
     }
     */
    private func buttonAddIs(visible : Bool) {
        deleteRecipeButton.isHidden = visible
        saveRecipeButton.isHidden = !visible
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
