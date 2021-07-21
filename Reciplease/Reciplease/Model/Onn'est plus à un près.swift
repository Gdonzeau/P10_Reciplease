//
//  Onn'est plus à un près.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 21/07/2021.
//

import Foundation
struct Employee: Codable {
    var name: String
    var id: Int
    var gift: Toy
}
struct Toy: Codable {
    var name: String
}

// 1
enum CodingKeys: CodingKey {
  case name, id, gift
}
// 2
enum GiftKeys: CodingKey {
  case toy
}
// 3
func encode(to encoder: Encoder) throws {
  var container = encoder.container(keyedBy: CodingKeys.self)
  try container.encode(name, forKey: .name)
  try container.encode(id, forKey: .id)
  // 4
  var giftContainer = container
    .nestedContainer(keyedBy: GiftKeys.self, forKey: .gift)
  try giftContainer.encode(favoriteToy, forKey: .toy)
}
