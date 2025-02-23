//
//  SearchHeaderView.swift
//  NomadNest
//
//  Created by Rocio Martos on 5/2/25.
//

import SwiftUI

struct SearchHeaderView: View {
    @Binding var searchQuery: String
    @State private var isEditing = false
    
    @State private var showStartDatePicker = false
    @State private var showEndDatePicker = false
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    @State private var showPassengerPicker = false
    @State private var adults = 1
    @State private var children = 0
    
    @State private var selectedOption: TravelOption = .hotel
    
    @State private var flights: [Flight] = [] // Aquí guardamos los vuelos que encontramos.
    @State private var isLoadingFlights = false
    
    enum TravelOption {
        case hotel, flight, hotelFlight
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Contenedor con fondo oscuro y esquinas redondeadas
            VStack(spacing: 10) {
                // Opciones de viaje dentro del mismo marco
                HStack(spacing: 20) {
                    travelOptionButton(icon: "bed.double.fill", option: .hotel)
                    travelOptionButton(icon: "airplane", option: .flight)
                    travelOptionButton(icon: "bed.double.fill", secondIcon: "airplane", option: .hotelFlight)
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
                
                // Campo de búsqueda de destino
                TextField("Buscar destino...", text: $searchQuery)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .onTapGesture {
                        self.isEditing = true
                    }
                    .overlay(
                        HStack {
                            Spacer()
                            if isEditing {
                                Button(action: {
                                    self.searchQuery = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing)
                            }
                        }
                    )
                    .font(.title3)
                    .foregroundColor(.black)
                    .keyboardType(.default)
                
                // Selección de Fechas
                HStack {
                    dateButton(title: "Inicio", date: $startDate, showPicker: $showStartDatePicker)
                    dateButton(title: "Fin", date: $endDate, showPicker: $showEndDatePicker)
                }
                
                // Selección de pasajeros
                Button(action: {
                    showPassengerPicker.toggle()
                }) {
                    HStack {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(Color(hex: "#f8be77"))
                        Text("Pasajeros: \(adults) Adultos, \(children) Niños")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                }
                
                // Mostrar los vuelos solo si la opción seleccionada es de vuelo
                if selectedOption == .flight {
                    VStack {
                        Text("Resultados de vuelos:")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        // Mostrar los vuelos si están disponibles
                        if isLoadingFlights {
                            ProgressView("Cargando vuelos...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .foregroundColor(.white)
                        } else if flights.isEmpty {
                            Text("No se han encontrado vuelos")
                                .foregroundColor(.white)
                        } else {
                            ForEach(flights, id: \.id) { flight in
                                VStack(alignment: .leading) {
                                    Text("\(flight.source) -> \(flight.destination)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Text("Precio: \(flight.price.total) \(flight.price.currency)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 5)
                            }
                        }
                    }
                    .padding()
                    .onAppear {
                        // Buscar vuelos solo si es la opción seleccionada
                        searchFlights()
                    }
                }
                
            }
            .padding()
            .background(Color(hex: "#363c46").opacity(0.9))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    private func travelOptionButton(icon: String, secondIcon: String? = nil, option: TravelOption) -> some View {
        Button(action: {
            selectedOption = option
            if option == .flight {
                searchFlights() // Llamamos a la búsqueda de vuelos cuando se selecciona la opción de vuelos
            }
        }) {
            HStack {
                Image(systemName: icon)
                if let secondIcon = secondIcon {
                    Image(systemName: secondIcon)
                }
            }
            .foregroundColor(Color(hex: "#f8be77"))
            .padding()
            .background(selectedOption == option ? Color(hex: "#363c46").opacity(0.9) : Color.clear)
            .cornerRadius(8)
        }
    }
    
    private func dateButton(title: String, date: Binding<Date>, showPicker: Binding<Bool>) -> some View {
        Button(action: {
            showPicker.wrappedValue.toggle()
        }) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(Color(hex: "#f8be77"))
                Text("\(title): \(formattedDate(date.wrappedValue))")
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
        .sheet(isPresented: showPicker) {
            DatePicker("Selecciona una fecha", selection: date, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func searchFlights() {
        isLoadingFlights = true
        // Aquí puedes colocar la lógica para buscar vuelos usando los parámetros de búsqueda
        // Simulación de búsqueda de vuelos, reemplázalo con tu implementación real:
        
        let dispatchWorkItem = DispatchWorkItem {
                flights = [
                    Flight(type: "Economy", id: "1", source: "Madrid", destination: "Barcelona", departure: "2025-03-01T10:00", arrival: "2025-03-01T11:30", price: Price(total: "100", currency: "EUR")),
                    Flight(type: "Economy", id: "2", source: "Madrid", destination: "Valencia", departure: "2025-03-02T14:00", arrival: "2025-03-02T15:30", price: Price(total: "120", currency: "EUR"))
                ]
                isLoadingFlights = false
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: dispatchWorkItem)
    }
}
#Preview {
    SearchHeaderView(searchQuery: .constant(""))
}
