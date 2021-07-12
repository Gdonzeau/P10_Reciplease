//
//  NetworkErrors.swift
//  Reciplease
//
//  Created by Guillaume Donzeau on 06/07/2021.
//

import Foundation
// Different potential errors
enum APIErrors: String, LocalizedError {
    
    case noData = "No data"
    case noError = "There is no error." // For tests
    case decodingError = "Decoding Error."
    case invalidURL = "Not the right adress."
    case invalidStatusCode = "Status invalid"
    case errorGenerated = "Error generated"
    case nothingIsWritten = "You must write something correct"
    case townUnknown = "Town Unknown"
    
    var errorDescription: String? {
        switch self {
        case .noData: return "Aucune donnée n'est renvoyée."
        case .noError:
            return "Tout va bien, pas d'erreur."
        case .decodingError:
            return "Le fichier renvoyé est endommagé."
        case .invalidURL:
            return "L'adresse internet est non conforme."
        case .invalidStatusCode:
            return "Le statut est invalide."
        case .errorGenerated:
            return "Erreur au moment de la requête réseau."
        case .nothingIsWritten:
            return "Vous devez écrire quelque chose de correct."
        case .townUnknown:
            return "Le nom de la ville est inconnu."
        }
    }
    var failureReason: String? {
        switch self {
        case .noData: return "Pas de données"
        case .noError:
            return "Pas d'erreur"
        case .decodingError:
            return "Erreur au décodage"
        case .invalidURL:
            return "Mauvaise adresse"
        case .invalidStatusCode:
            return "Statut invalide"
        case .errorGenerated:
            return "Erreur requête réseau"
        case .nothingIsWritten:
            return "Entrée non compréhensible"
        case .townUnknown:
            return "Nom de ville inconnu"
        }
    }
}
