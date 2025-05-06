//
//  HotelListView.swift
//  NomadNest
//
//  Created by Rocio Martos on 9/3/25.
//

import SwiftUI

struct HotelListView: View {
    var startDate: Date
    var endDate: Date
    var destination: String
    var flightDetails: Flight? // Recibimos los detalles del vuelo
    
    @StateObject private var viewModel = HotelListViewModel()
    @State private var selectedHotel: Place? = nil
    @State private var showReservationSheet = false
    
    private var numberOfNights: Int {
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.day], from: startDate, to: endDate)
        return difference.day ?? 1
    }
    
    private var totalPrice: Double {
        let hotelPrice = (selectedHotel?.pricePerNight ?? 0) * Double(numberOfNights) // Calcular el precio total del hotel
        let flightPrice = flightDetails?.price ?? 0
        return hotelPrice + flightPrice
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Hoteles en \(destination)")
                        .font(.title)
                        .bold()
                        .padding(.top)
                    
                    if viewModel.isLoading {
                        ProgressView("Cargando hoteles...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else if viewModel.hotels.isEmpty {
                        VStack {
                            Image(systemName: "bed.double.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                            Text("No se encontraron hoteles en \(destination).")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(viewModel.hotels, id: \.id) { hotel in
                                    Button {
                                        selectedHotel = hotel
                                        showReservationSheet = true
                                    } label: {
                                        HotelRowView(
                                            viewModel: viewModel,
                                            hotel: hotel,
                                            numberOfNights: numberOfNights
                                        )
                                        .padding(.horizontal, 16)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.bottom, 80) // Espacio para la barra
                        }
                    }
                    
                    // Mostrar los detalles del vuelo y el precio total
                    if let flight = flightDetails {
                        Text("Detalles del vuelo:")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top)
                        
                        Text("Origen: \(flight.origin) → Destino: \(flight.destination)")
                            .foregroundColor(.white)
                        Text("Fecha de salida: \(flight.departureDate)")
                            .foregroundColor(.white)
                        Text("Precio del vuelo: \(String(format: "%.2f €", flight.price))")
                            .foregroundColor(.white)
                    }
                    
                    Text("Precio Total (Vuelo + Hotel): \(String(format: "%.2f €", totalPrice))")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    Spacer()
                }
                .padding()
                
                // Barra de navegación fija en la parte inferior
                VStack {
                    Spacer()
                    BottomNavigationBar()
                        .padding(.bottom, 0)
                        .frame(maxWidth: .infinity)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadHotels(for: destination)
            }
            .sheet(isPresented: $showReservationSheet) {
                if let hotel = selectedHotel {
                    HotelReservationSheetView(
                        hotel: hotel,
                        startDate: startDate,
                        endDate: endDate
                    )
                }
            }
        }
    }
}

#Preview {
    HotelListView(
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400),
        destination: "Madrid",
        flightDetails: Flight(
            id: 1,  // Añadimos un id único para el vuelo
            origin: "Madrid",
            destination: "Barcelona",
            departureDate: "2025-05-01",
            returnDate: "2025-05-05",
            price: 100.0
        )
    )
}
