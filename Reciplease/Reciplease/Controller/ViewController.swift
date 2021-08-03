//
//  ViewController.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 05/07/2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test()
    }
    func test() {
        var essai = ""
        let interval: TimeInterval = 60
        
        let formatter = DateComponentsFormatter()
        essai = formatter.string(from: interval)!
        print(essai)
        formatter.unitsStyle = .positional
        essai = formatter.string(from: interval)!
        print(essai)
        if interval >= 3600 {
        formatter.allowedUnits = [.hour, .minute]
        } else {
            formatter.allowedUnits = [.minute]
        }
        essai = formatter.string(from: interval)!
        print(essai) // S'arrêter là pour l'affichage
        /*
        formatter.zeroFormattingBehavior = .pad
        essai = formatter.string(from: interval)!
        print(essai)
        formatter.collapsesLargestUnit = false
        essai = formatter.string(from: interval)!
        print(essai)
        */
        if let final = formatter.string(from: interval) {
            if interval >= 3600 {
            print("Time : \(final) h")
            } else {
                print("Time : \(final) m")
            }
        }
    }
}

