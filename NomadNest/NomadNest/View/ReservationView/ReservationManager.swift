//
//  ReservationManager.swift
//  NomadNest
//
//  Created by Rocio Martos on 21/4/25.
//

import Foundation
class ReservationManager: ObservableObject {
    static let shared = ReservationManager()
    
    @Published var reservations: [Reservation] = []

    private init() {}

    func addReservation(_ reservation: Reservation) {
        reservations.append(reservation)
    }
}
