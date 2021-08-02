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
    }
}
