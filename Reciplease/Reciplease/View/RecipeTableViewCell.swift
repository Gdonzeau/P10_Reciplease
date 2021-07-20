//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var imageBackgroundCell: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var blackLine: UIView!
    var recipe: Recipe {
        didSet {
            imageBackgroundCell.load(url: imageURL)
            recipeName.text = recipe.name
            //recipeName.font(.custom("OpenSans-Bold", size: 34))
            totalTime.text = recipe.timeToPrepare
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        // Initialization code
    }
    private func addShadow() {
        
        blackLine.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        blackLine.layer.shadowRadius = 0.0
        blackLine.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        blackLine.layer.shadowOpacity = 2.0
        //imageBackgroundCell.layer.masksToBounds = false
 
        /*
        imageBackgroundCell.layer.shadowColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.7).cgColor
        imageBackgroundCell.layer.shadowOpacity = 0.3
        imageBackgroundCell.layer.shadowOffset = CGSize.zero
        imageBackgroundCell.layer.shadowRadius = 6
        imageBackgroundCell.layer.masksToBounds = false
        //imageBackgroundCell.layer.borderWidth = 1.5
        //imageBackgroundCell.layer.borderColor = UIColor.white.cgColor
        imageBackgroundCell.layer.cornerRadius = imageView?.bounds.width ?? 1 / 2
 */
    }
    func configure(image: UIImageView, timeToPrepare: String, imageURL: URL, name: String) {
        imageBackgroundCell.load(url: imageURL)
        recipeName.text = name
        //recipeName.font(.custom("OpenSans-Bold", size: 34))
        totalTime.text = timeToPrepare
        
    }
}
