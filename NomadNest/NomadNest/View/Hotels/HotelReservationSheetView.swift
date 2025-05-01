//
//  Untitled.swift
//  NomadNest
//
//  Created by Rocio Martos on 21/4/25.
//

import SwiftUI

struct HotelReservationSheetView: View {
    let hotel: Place
    let startDate: Date
    let endDate: Date
    
    let roomTypes: [RoomType] = [
        RoomType(name: "Estándar Doble", description: "Cama doble, baño privado y aire acondicionado.", priceMultiplier: 1.0),
        RoomType(name: "Suite Junior", description: "Cama Queen, zona de estar, baño moderno y balcón.", priceMultiplier: 1.4),
        RoomType(name: "Suite", description: "Cama King, baño de lujo, salón privado y vistas al mar.", priceMultiplier: 1.8)
    ]
    
    @State private var selectedRoomType: RoomType?
    @State private var showConfirmationAlert = false
    @State private var reservationToConfirm: Reservation?
    
    @State private var navigateToReservations = false
    
    var numberOfNights: Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 1
    }
    
    var totalPrice: Double {
        let basePrice = hotel.pricePerNight ?? 100
        let multiplier = selectedRoomType?.priceMultiplier ?? 1.0
        return Double(numberOfNights) * basePrice * multiplier
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top)
            
            Text(hotel.name)
                .font(.title2)
                .bold()
            
            Text("📅 \(startDate.formatted(date: .abbreviated, time: .omitted)) - \(endDate.formatted(date: .abbreviated, time: .omitted))")
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Elige tipo de habitación:")
                    .font(.headline)
                
                ForEach(roomTypes) { room in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(room.name).bold()
                            Text(room.description).font(.caption).foregroundColor(.gray)
                        }
                        Spacer()
                        if selectedRoomType == room {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.orange)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedRoomType = room
                    }
                    .padding(.vertical, 5)
                }
            }
            
            Text("💰 Total por \(numberOfNights) noche(s): \(String(format: "%.2f", totalPrice)) €")
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                guard let room = selectedRoomType else { return }
                let reservation = Reservation(
                    hotelName: "\(hotel.name) - \(room.name)",
                    startDate: startDate,
                    endDate: endDate,
                    totalPrice: totalPrice
                )
                // Mostrar la alerta de confirmación
                reservationToConfirm = reservation
                showConfirmationAlert = true
            }) {
                Text("Reservar ahora")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedRoomType == nil ? Color.gray : Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selectedRoomType == nil)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .presentationDetents([.fraction(0.6)])
        .alert(isPresented: $showConfirmationAlert) {
            // Confirmación antes de guardar la reserva
            Alert(
                title: Text("Confirmar Reserva"),
                message: Text("""
                    Hotel: \(reservationToConfirm?.hotelName ?? "Desconocido")
                    Fechas: \(startDate.formatted(date: .abbreviated, time: .omitted)) - \(endDate.formatted(date: .abbreviated, time: .omitted))
                    Precio total: \(String(format: "%.2f", totalPrice)) €
                    Tipo de habitación: \(selectedRoomType?.name ?? "Desconocido")
                    """),
                primaryButton: .default(Text("Confirmar")) {
                    if let reservation = reservationToConfirm {
                        // Guardamos la reserva
                        ReservationManager.shared.addReservation(reservation)
                    }
                    // Navegar a la vista de reservas
                    navigateToReservations = true
                },
                secondaryButton: .cancel() {
                    print("Reserva cancelada.")
                }
            )
        }
        .background(
            NavigationLink(destination: ReservationsView(), isActive: $navigateToReservations) {
                EmptyView()
            }
        )
    }
}

#Preview {
    // Crear una reserva de prueba
    let fakeReservation = Reservation(
        hotelName: "Hotel Ejemplo",
        startDate: Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
        totalPrice: 300.0
    )
    
    // Crear una instancia de Place con todos los parámetros necesarios
    let fakePlace = Place(
        id: "123",  // Un valor para 'id' (puede ser un identificador único)
        name: "Hotel Ejemplo",
        vicinity: "Playa Dorada, Ciudad, País",  // Ubicación del hotel
        rating: 4.5,  // Calificación
        types: ["hotel", "resort"],  // Tipos de lugar
        geometry: Geometry(location: Location(lat: 28.123, lng: -15.123)),  // Ejemplo de coordenadas de ubicación
        pricePerNight: 100  // Precio por noche
    )
    
    // Inyectar la reserva en el gestor de reservas
    let manager = ReservationManager.shared
    manager.reservations = [fakeReservation] // Añadir la reserva de prueba
    
    // Retornar la vista que quieres previsualizar
    return HotelReservationSheetView(
        hotel: fakePlace,  // Pasa el lugar con todos los valores
        startDate: fakeReservation.startDate,
        endDate: fakeReservation.endDate
    )
}
