//
//  ViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 05/07/2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    let adressUrl = "https://api.edamam.com/api/recipes/v2?type=public"
    
    let headers: HTTPHeaders = [
        .authorization(username: Keys.id.rawValue, password: Keys.key.rawValue),
        .accept("application/json")
    ]
    let parameters = ["app_id": Keys.id.rawValue,"app_key":Keys.key.rawValue, "q": "Chicken,Tomatoes", "diet": "balanced"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let finalAdressUrl = adressUrl
        AF.request(finalAdressUrl, parameters: parameters).responseJSON {response in
            debugPrint(response)
            
        }
    }
}

