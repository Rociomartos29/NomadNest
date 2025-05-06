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
    var autoNavigateToHotels: Bool = false
    
    @StateObject private var flightViewModel = FlightViewModel()
    @State private var navigateToHotels = false
    @State private var selectedFlight: Flight? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#363c46").ignoresSafeArea() // Fondo
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 16) {
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
                                VStack(spacing: 12) {
                                    ForEach(flightViewModel.flights) { flight in
                                        Button(action: {
                                            selectedFlight = flight
                                            navigateToHotels = true
                                        }) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("✈️ \(flight.origin) → \(flight.destination)")
                                                    .font(.headline)
                                                Text("Salida: \(flight.departureDate) | Regreso: \(flight.returnDate)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                                Text(String(format: "Precio: %.2f €", flight.price))
                                                    .font(.subheadline)
                                            }
                                            .padding()
                                            .background(Color.white.opacity(10))
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            NavigationLink(
                                destination: HotelListView(
                                    startDate: stringToDate(departureDate),
                                    endDate: stringToDate(returnDate),
                                    destination: destination,
                                    flightDetails: selectedFlight // Pasamos los detalles del vuelo
                                ),
                                isActive: $navigateToHotels
                            ) {
                                EmptyView() // Este es el enlace oculto que se activa cuando seleccionamos un vuelo
                            }
                        }
                        .padding(.bottom, 100) // Espacio extra para evitar que la barra tape contenido
                    }
                    
                    Spacer() // Empuja todo hacia arriba si hay poco contenido
                }
                
                VStack {
                    Spacer()
                    Divider()
                    BottomNavigationBar()
                        .padding(.bottom, 8)
                        .background(Color(hex: "#363c46"))
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .onAppear {
                flightViewModel.searchFlights(
                    from: origin,
                    to: destination,
                    departureDate: departureDate,
                    returnDate: returnDate
                )
                
                if autoNavigateToHotels {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        navigateToHotels = true
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func stringToDate(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString) ?? Date()
    }
}
#Preview {
    NavigationStack {
        FlightView(
            origin: "Madrid",
            destination: "Barcelona",
            departureDate: "2025-05-01",
            returnDate: "2025-05-05",
            autoNavigateToHotels: false
        )
    }
}
