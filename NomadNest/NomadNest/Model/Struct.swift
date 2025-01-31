//
//  Trip.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import Foundation

struct Trip: Identifiable {
    var id = UUID()
    var destination: String
    var startDate: Date
    var endDate: Date
    var tasks: [String]
}
struct Destination: Identifiable, Decodable {
    var id: String { title } // Para que sea identificable en List
    let title: String
    let summary: String
    let url: String
}

struct GeoNamesResponse: Decodable {
    let geonames: [Destination]
}
struct DestinationSuggestion: Identifiable, Decodable {
    let id = UUID()  // Esto hace que sea Identifiable
    let city: String
    let country: String
    let description: String
    let category: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
            case city
            case country
            case description
            case category
            case imageURL = "image_url" // Si en el JSON la clave es "image_url" en lugar de "imageURL"
        }
}
// Estructura para representar un usuario
struct User: Identifiable, Decodable {
    var id: String
    var email: String
    var firstName: String
    var lastName: String
    var token: String  // Token de autenticación si es necesario

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case token
    }
}
