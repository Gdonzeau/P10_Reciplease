//
//  InfoView.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 02/08/2021.
//

import UIKit

class InfoView: UIView {
    
    
    var recipe: Recipe? {
        didSet {
            configureView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        // Initialization code
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private func configureView() {
        
        let preparationTime = UILabel()
        preparationTime.textAlignment = .center
        preparationTime.translatesAutoresizingMaskIntoConstraints = false //Utilise autolayout
        preparationTime.text = "Bonjour"
        let howManyPerson = UILabel()
        howManyPerson.textAlignment = .center
        howManyPerson.translatesAutoresizingMaskIntoConstraints = false
    }
}
