//
//  RecipeChoosenViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 14/07/2021.
//

import UIKit

class RecipeChoosenViewController: UIViewController {

    var recipeName = String()
    @IBOutlet weak var blogNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        blogNameLabel.text = recipeName
    }
    
}
