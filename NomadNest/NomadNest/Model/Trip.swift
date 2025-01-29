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
