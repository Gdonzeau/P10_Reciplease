//
//  RecipeChoosenViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit
import CoreData
import WebKit

class RecipeChoosenViewController: UIViewController {
    
    var recipeName = String()
    var ingredientList = String()
    var recipeChoosen = RecipeType(name: "", imageUrl: "", ingredientsNeeded: [], duration: 0.00, url: "", numberOfPeople: 0)
    
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsList: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var favoriteOrNot: UIButton!
    @IBOutlet weak var newImageRecipe: UIView!
    @IBOutlet weak var infoView: InfoView!
    
    @IBAction func favoriteOrNotChange(_ sender: UIButton) {
        saveOrDelete()
    }
    
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        openUrl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isRecipeNotFavorite(answer: isRecipeNotAlreadyRegistred())
        favoriteOrNot.contentVerticalAlignment = .fill
        favoriteOrNot.contentHorizontalAlignment = .fill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareInformations()
        blogNameLabel.text = recipeName
        ingredientsList.text = ingredientList
        var urlImage = ""
        // Remplacer par des if pour des valeurs par défaut ?
        if let imageUrl = recipeChoosen.imageUrl {
            urlImage = imageUrl
        } else {
            let error = APIErrors.noImage
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
            allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
        }
        if let imageUrlUnwrapped = URL(string: urlImage) {
            imageRecipe.load(url: imageUrlUnwrapped)
        } else {
            let error = APIErrors.noImage
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
            allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
            imageRecipe.image = UIImage(named: "imageDefault") // No image, so Default image
        }
        
    }
    private func saveOrDelete() {
        if isRecipeNotAlreadyRegistred() == true {
            favoriteOrNot.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            savingRecipe(recipeToSave: recipeChoosen)
        } else {
            favoriteOrNot.setImage(UIImage(systemName: "heart"), for: .normal)
            deleteRecipeFromCoreData()
        }
    }
    private func openUrl() {
        if let url = recipeChoosen.url {
            guard let urlAdress = URL(string: url) else {
                return
            }
            UIApplication.shared.open(urlAdress)
        } else {
            let error = APIErrors.noUrl
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
            allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
            print("no url") // Ajouter un message d'erreur
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
    
    private func createRecipeObject(object:RecipeEntity) -> RecipeType {
        guard let name = object.name, let ingredients = object.ingredients else {
            return RecipeType(name: "", ingredientsNeeded: [], duration: 0, numberOfPeople: 0) // A modifier
        }
        let url = object.url
        let image = object.imageUrl
        let totalTime = object.totalTime
        let person = Int(object.person)
        let recipe = RecipeType(name: name, imageUrl: image, ingredientsNeeded: ingredients, duration: totalTime, url: url, numberOfPeople: person)
        return recipe
    }
    
    private func isRecipeNotAlreadyRegistred()-> Bool {
        if RecipeEntity.all.count == 0 { // If there is no recipe in favorite
            return true
        }
        for object in RecipeEntity.all {
            if createRecipeObject(object: object) == recipeChoosen { // is the recipe on the View already favorit ?
                return false
            }
        }
        return true
    }
    
    private func savingRecipe(recipeToSave: RecipeType) {
        let recipe = RecipeEntity(context: AppDelegate.viewContext) //Appel du CoreDate RecipeService
        recipe.saveRecipe(recipeToSave: recipeToSave)
    }
    
    private func deleteRecipeFromCoreData() {
        for object in RecipeEntity.all {
            if createRecipeObject(object: object) == recipeChoosen {
                print("Trouvé, on efface")
                AppDelegate.viewContext.delete(object)
                try? AppDelegate.viewContext.save()
                return
            } else {
                print("Absent de la base de données") // At each step where it is not the  right recipe
            }
        }
    }
    private func isRecipeNotFavorite(answer : Bool) {
        if answer == false {
            favoriteOrNot.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteOrNot.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    private func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
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
