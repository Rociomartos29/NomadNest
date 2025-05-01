//
//  ReservationsView().swift
//  NomadNest
//
//  Created by Rocio Martos on 5/2/25.
//

import SwiftUI

struct ReservationsView: View {
    @ObservedObject var reservationManager = ReservationManager.shared
    @State private var showDeleteAlert = false
    @State private var reservationToDelete: Reservation?
    
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
                        VStack(alignment: .leading, spacing: 8) {
                            Text(reservation.hotelName)
                                .font(.headline)
                            Text("📅 \(reservation.startDate.toReadableString()) - \(reservation.endDate.toReadableString())")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("💰 \(reservation.totalPrice, specifier: "%.2f") €")
                                .font(.subheadline)
                            
                            HStack {
                                Button(action: {
                                    // Al presionar cancelar, mostrar el alert
                                    reservationToDelete = reservation
                                    showDeleteAlert = true
                                }) {
                                    Label("Cancelar", systemImage: "trash")
                                        .foregroundColor(.red)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    // Aquí puedes navegar a una vista para modificar la reserva
                                    print("Modificar reserva")
                                }) {
                                    Label("Modificar", systemImage: "pencil")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.top, 5)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Mis Reservas")
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("¿Estás seguro?"),
                    message: Text("Esta acción eliminará permanentemente la reserva."),
                    primaryButton: .destructive(Text("Eliminar")) {
                        if let reservationToDelete = reservationToDelete,
                           let index = reservationManager.reservations.firstIndex(where: { $0.id == reservationToDelete.id }) {
                            reservationManager.reservations.remove(at: index)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
#Preview {
    let fakeReservation = Reservation(
        
        hotelName: "Hotel Ejemplo",
        startDate: Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
        totalPrice: 300.0
    )
    
    let manager = ReservationManager.shared
    manager.reservations = [fakeReservation] // Inyectamos una reserva de prueba
    
    return ReservationsView()
}
