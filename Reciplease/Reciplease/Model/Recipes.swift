//
//  Recette.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 08/07/2021.
//

import Foundation

struct RecipeReceived {
    var name: String
    var image: URL?
    var ingredientsNeeded: [String]
    var totalTime: Float
    var url: URL?
    var elevation: String
    
    enum CodingKeys: String, CodingKey {
        
        case additionnalInfo
    }
    enum AdditionalInfoKeys: String, CodingKey {
        case elevation
        case name
        case image
        case ingredientsNeeded
        case totalTime
        case url
    }
}

struct Recipes: Decodable {
    
    var recipes: [Hit]
    
    enum CodingKeys: String, CodingKey {
        
        case recipes = "hits"
    }
}
struct Hit: Decodable {
    var recipe: Recipe
    /*
     enum CodingKeys: String, CodingKey {
     case recipe
     // case links = "_links"
     }
     */
}

struct Recipe : Decodable {
    var named: String
    var image: URL
    var ingredientsNeeded: [String]
    var totalTime: Float
    var url: URL
    
    enum CodingKeys: String, CodingKey {
        
        case named = "label"
        case image
        case ingredientsNeeded = "ingredientLines"
        case totalTime
        case url
    }
    /*
     init(from decoder: Decoder) throws {
     let container = try decoder.container(keyedBy: CodingKeys.self)
     id = try container.decode(Int.self, forKey: .id)
     missionName = try container.decode(String.self, forKey: .missionName)
     date = try container.decode(Date.self, forKey: .date)
     succeeded = try container.decode(Bool.self, forKey: .succeeded)
     timeline = try container.decodeIfPresent(Timeline.self, forKey: .timeline)
     
     let linksContainer = try container.nestedContainer(keyedBy: CodingKeys.LinksKeys.self, forKey: .links)
     patchURL = try linksContainer.decode(URL.self, forKey: .patchURL)
     
     let siteContainer = try container.nestedContainer(keyedBy: CodingKeys.SiteKeys.self, forKey: .launchSite)
     site = try siteContainer.decode(String.self, forKey: .siteName)
     
     let rocketContainer = try container.nestedContainer(keyedBy: CodingKeys.RocketKeys.self, forKey: .rocket)
     rocket = try rocketContainer.decode(String.self, forKey: .rocketName)
     let secondStageContainer = try rocketContainer.nestedContainer(keyedBy: CodingKeys.RocketKeys.SecondStageKeys.self, forKey: .secondStage)
     
     var payloadsContainer = try secondStageContainer.nestedUnkeyedContainer(forKey: .payloads)
     var payloads = ""
     while !payloadsContainer.isAtEnd {
     let payloadContainer = try payloadsContainer.nestedContainer(keyedBy: CodingKeys.RocketKeys.SecondStageKeys.PayloadKeys.self)
     let payloadName = try payloadContainer.decode(String.self, forKey: .payloadName)
     payloads += payloads == "" ? payloadName : ", \(payloadName)"
     }
     self.payloads = payloads
     }
     */
}
extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.named == rhs.named && lhs.url == rhs.url // if var(de type Recipe) == var(
    }
}
