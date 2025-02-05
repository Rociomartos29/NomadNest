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

// Estructura para un destino individual
struct Destination: Decodable, Identifiable {
    let id: Int
    let title: String
    let country: String
    let description: String
    let category: String
    let imageUrl: String
    
    // Decodificar el campo 'image_url' en 'imageUrl'
    enum CodingKeys: String, CodingKey {
        case id, title, country, description, category
        case imageUrl = "image_url"
    }
}

// Estructura para la respuesta completa de los destinos
struct DestinationsResponse: Decodable {
    let destinations: [Destination]
}
struct LoginResponse: Decodable {
    let message: String
    let user: User
}
// Estructura para representar un usuario
struct User: Identifiable, Decodable {
    let id: Int
    let nombre: String
    let apellidos: String
    let email: String
    let password: String
}

enum CodingKeys: String, CodingKey {
    case id
    case email
    case nombre = "nombre"
    case apellidos = "apellidos"
    case password
}

