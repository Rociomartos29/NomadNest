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
    
    var numberOfNights: Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 1
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
            
            Text("💰 Total por \(numberOfNights) noche(s): \(String(format: "%.2f", Double(numberOfNights) * (hotel.pricePerNight ?? 100))) €")
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                let reservation = Reservation(
                    hotelName: hotel.name,
                    startDate: startDate,
                    endDate: endDate,
                    totalPrice: Double(numberOfNights) * (hotel.pricePerNight ?? 100)
                )
                ReservationManager.shared.addReservation(reservation)
            }) {
                Text("Reservar ahora")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .presentationDetents([.fraction(0.4)])
    }
}
