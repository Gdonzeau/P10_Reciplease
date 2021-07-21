//
//  Onn'est plus à un près.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 21/07/2021.
//

import Foundation

struct Toy: Codable {
  var name: String
}

struct Employee: Codable {
  var name: String
  var id: Int
  var favoriteToy: Toy
}

let toy = Toy(name: "Teddy Bear")

let employee = Employee(name: "John Appleseed", id: 7, favoriteToy: toy)
