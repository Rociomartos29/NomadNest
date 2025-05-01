//
//  ReservationManager.swift
//  NomadNest
//
//  Created by Rocio Martos on 21/4/25.
//

import Foundation

class ReservationManager: ObservableObject {
    static let shared = ReservationManager()
    
    @Published var reservations: [Reservation] = [] {
        didSet {
            saveReservations()
        }
    }
    
    private init() {
        loadReservations()
    }
    
    func addReservation(_ reservation: Reservation) {
        reservations.append(reservation)
    }
    
    // Guardar reservas en UserDefaults
    private func saveReservations() {
        if let encoded = try? JSONEncoder().encode(reservations) {
            UserDefaults.standard.set(encoded, forKey: "reservations")
        }
    }
    
    // Cargar reservas desde UserDefaults
    private func loadReservations() {
        if let data = UserDefaults.standard.data(forKey: "reservations"),
           let decodedReservations = try? JSONDecoder().decode([Reservation].self, from: data) {
            reservations = decodedReservations
        }
    }
}
