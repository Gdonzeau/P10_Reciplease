//
//  Recettes.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 08/07/2021.
//

import Foundation

struct Recettes: Decodable {
    
    let all: [Recipes]
    
    enum CodingKeys: String, CodingKey {
        
      case all = "hits"
    }
  }
