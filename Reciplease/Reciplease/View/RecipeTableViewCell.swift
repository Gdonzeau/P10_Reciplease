//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var howManyPerson: UILabel!
    //@IBOutlet weak var blackLine: UIView!
    /*
     //Ajouter didSet
    var recipe: RecipeType {
        didSet {
            if let image = recipe.image {
                if let url = URL(string: image) {
                imageBackgroundCell.load(url: url)
                }
            }
            recipeName.text = recipe.name
            //recipeName.font(.custom("OpenSans-Bold", size: 34))
            totalTime.text = String(recipe.totalTime)
        }
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        // Initialization code
    }
    private func addShadow() {
        /*
        blackLine.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        blackLine.layer.shadowRadius = 0.0
        blackLine.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        blackLine.layer.shadowOpacity = 2.0
 */
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
    func configure(timeToPrepare: String, name: String, person: Int) {
        let interval: TimeInterval = Double(timeToPrepare) ?? 0

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .pad
        formatter.collapsesLargestUnit = false

        guard let time = formatter.string(from: interval*60) else {
            return
        }
        if time == "00:00" {
            timing.isHidden = true
        } else {
            timing.isHidden = false
        }
        if person == 0 {
            howManyPerson.isHidden = true
        } else {
            howManyPerson.isHidden = false
        }
        
        recipeName.text = "  " + name
        recipeName.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        //recipeName.font(.custom("OpenSans-Bold", size: 34))
        timing.text = " 🕒 : " + time
        howManyPerson.text = " Pers: \(String(person))"
        //informations.text =  "🕒 : " + time + " min. \n Pers: \(String(person))"
        timing.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        howManyPerson.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        
        
        
    }
}
// Because of : 'NSKeyedUnarchiveFromData' should not be used to for un-archiving and will be removed in a future release
extension RecipeTableViewCell: NSSecureCoding {
    static var supportsSecureCoding = true
}
