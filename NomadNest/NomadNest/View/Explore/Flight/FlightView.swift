//
//  SwiftUIView.swift
//  NomadNest
//
//  Created by Rocio Martos on 23/2/25.
//

import SwiftUI

struct FlightView: View {
    let origin: String
    let destination: String
    let departureDate: String
    let returnDate: String
    
    @StateObject private var flightViewModel = FlightViewModel()
    
    var body: some View {
        VStack {
            Text("Vuelos de \(origin) a \(destination)")
                .font(.title)
                .foregroundColor(.white)
                .padding()
            
            if flightViewModel.isLoading {
                ProgressView("Buscando vuelos...")
                    .foregroundColor(.white)
            } else if let errorMessage = flightViewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if flightViewModel.flights.isEmpty {
                Text("No se encontraron vuelos")
                    .foregroundColor(.white)
            } else {
                List(flightViewModel.flights, id: \..id) { flight in
                    VStack(alignment: .leading) {
                        Text("✈️ \(flight.source) -> \(flight.destination)")
                            .font(.headline)
                        Text("Precio: \(flight.price.total) \(flight.price.currency)")
                            .font(.subheadline)
                    }
                }
            }
        }
        .onAppear {
            flightViewModel.searchFlights(from: origin, to: destination, departureDate: departureDate, returnDate: returnDate)
        }
        .padding()
        .background(Color(hex: "#363c46"))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    FlightView(origin: "MAD", destination: "BCN", departureDate: "2025-03-01", returnDate: "2025-03-05")
}
