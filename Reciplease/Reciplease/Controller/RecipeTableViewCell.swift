//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBAction func recipeButton(_ sender: UIButton) {
        //performSegue(withIdentifier: "segueFromCellToRecipeChoosen", sender: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
/*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("Selected !")
        
        // Configure the view for the selected state
    }
 */
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromCellToRecipeChoosen" {
            print("C'est bon.")
        }
    }
*/
}
