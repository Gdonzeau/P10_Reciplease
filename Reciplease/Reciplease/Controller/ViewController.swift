//
//  ViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 05/07/2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    let adressUrl = "https://httpbin.org/headers"
    let headers: HTTPHeaders = [
        .authorization(username: "test@email.com", password: "testpassword"),
        .accept("application/json")
    ]
    let parameters = ["category": "Movies", "genre": "Action"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        AF.request(adressUrl, parameters: parameters, headers: headers).responseJSON {response in
            debugPrint(response)    }    }


}

