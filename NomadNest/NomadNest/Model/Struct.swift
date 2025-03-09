//
//  Trip.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import Foundation
// Estructura para representar un viaje
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

// Estructura para la respuesta del login
struct LoginResponse: Decodable {
    let message: String
    let user: User
    let token: String?
}

// Estructura para representar un usuario
struct User: Identifiable, Decodable {
    let id: Int
    let nombre: String
    let apellidos: String
    let email: String
    
    // Decodificación de las claves en el JSON
    enum CodingKeys: String, CodingKey {
        case id
        case nombre
        case apellidos
        case email
    }
}

// Estructuras para manejar la respuesta de Google Places API
struct GooglePlacesResponse: Codable {
    let results: [Place]
    let status: String
}

struct Place: Codable, Identifiable {
    let id: String // "place_id" en la respuesta JSON
    let name: String
    let vicinity: String? // Este campo puede ser opcional
    let rating: Double? // La calificación, opcional si no se proporciona
    let types: [String]? // Los tipos del lugar, opcional si no se proporciona
    let geometry: Geometry
    var photos: [Photo]? // Fotos relacionadas con el lugar, opcional
    var pricePerNight: Double? // Precio por noche (opcional)

    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case name, vicinity, rating, types, geometry, photos
    }
}

struct Photo: Codable {
    let photo_reference: String
    let height: Int
    let width: Int
    let html_attributions: [String]?

    // Función para obtener la URL de la imagen usando la API de Google Maps
    func getImageURL(apiKey: String) -> String {
        let baseURL = "https://maps.googleapis.com/maps/api/place/photo"
        return "\(baseURL)?maxwidth=\(width)&maxheight=\(height)&photoreference=\(photo_reference)&key=\(apiKey)"
    }
}
struct Geometry: Codable {
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}

struct GeocodeResponse: Codable {
    let results: [GeocodeResult]
}

struct GeocodeResult: Codable {
    let geometry: Geometry
}
struct AmadeusFlightResponse: Decodable {
    let data: [Flight]
}

struct Flight: Codable {
    let type: String
    let id: String
    let source: String
    let destination: String
    let departure: String
    let arrival: String
    let price: Price
}

struct Price: Codable {
    let total: String
    let currency: String
}

struct Itinerary: Decodable {
    let segments: [Segment]
}

struct Segment: Decodable {
    let departure: Departure
    let arrival: Arrival
}

struct Departure: Decodable {
    let airport: String
    let dateTime: String
}

struct Arrival: Decodable {
    let airport: String
    let dateTime: String
}
struct FlightOffersResponse: Codable {
    let data: [Flight]
}
