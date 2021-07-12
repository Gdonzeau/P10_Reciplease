//
//  ReceipeListViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 12/07/2021.
//

import UIKit

class ReceipeListViewController: ViewController {
    var recipesSended = Recipes?.self

    @IBOutlet weak var receipesTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let reception = recipesSended {
        print("reçu : \(reception)")
        }
        // Do any additional setup after loading the view.
    }
    
}
/*
extension ReceipeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
 */
