//
//  ReservationsView().swift
//  NomadNest
//
//  Created by Rocio Martos on 5/2/25.
//

import SwiftUI

struct ReservationsView: View {
    @ObservedObject var reservationManager = ReservationManager.shared
    
    var body: some View {
        NavigationView {
            List {
                if reservationManager.reservations.isEmpty {
                    Text("Aún no has hecho ninguna reserva.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ForEach(reservationManager.reservations) { reservation in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(reservation.hotelName)
                                .font(.headline)
                            Text("📅 \(reservation.startDate.toReadableString()) - \(reservation.endDate.toReadableString())")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("💰 \(reservation.totalPrice, specifier: "%.2f") €")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Mis Reservas")
        }
    }
}
#Preview {
    ReservationsView()
}
