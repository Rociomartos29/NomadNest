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
    
    // Variables para las ciudades de origen y destino
    @State private var originQuery: String = ""
    @State private var destinationQuery: String = ""
    
    @State private var navigateToFlights = false
    @State private var navigateToHotelList = false
    
    enum TravelOption {
        case hotel, flight, hotelFlight
    }

    
    var body: some View {
          VStack(spacing: 20) {
              VStack(spacing: 10) {
                  // Opciones de viaje
                  HStack(spacing: 20) {
                      travelOptionButton(icon: "bed.double.fill", option: .hotel)
                      travelOptionButton(icon: "airplane", option: .flight)
                      travelOptionButton(icon: "bed.double.fill", secondIcon: "airplane", option: .hotelFlight)
                  }
                  .padding(8)
                  .frame(maxWidth: .infinity)
                  .background(Color.white.opacity(0.2))
                  .cornerRadius(8)

                  // Buscador de destino
                  TextField("Buscar destino...", text: $searchQuery)
                      .padding()
                      .background(Color.white.opacity(0.8))
                      .cornerRadius(8)
                      .onTapGesture { self.isEditing = true }
                      .font(.title3)
                      .foregroundColor(.black)

                  // Solo mostrar campo de origen si aplica
                  if selectedOption == .flight || selectedOption == .hotelFlight {
                      TextField("Buscar origen...", text: $originQuery)
                          .padding()
                          .background(Color.white.opacity(0.8))
                          .cornerRadius(8)
                          .onTapGesture { self.isEditing = true }
                          .font(.title3)
                          .foregroundColor(.black)
                  }

                  // Selección de fechas
                  HStack {
                      dateButton(title: "Inicio", date: $startDate, showPicker: $showStartDatePicker)
                      dateButton(title: "Fin", date: $endDate, showPicker: $showEndDatePicker)
                  }

                  if showStartDatePicker {
                      DatePicker("", selection: $startDate, in: Date()..., displayedComponents: .date)
                          .datePickerStyle(GraphicalDatePickerStyle())
                          .padding()
                          .background(Color.white.opacity(0.8))
                          .cornerRadius(8)
                          .onChange(of: startDate) { _ in showStartDatePicker = false }
                  }

                  if showEndDatePicker {
                      DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                          .datePickerStyle(GraphicalDatePickerStyle())
                          .padding()
                          .background(Color.white.opacity(0.8))
                          .cornerRadius(8)
                          .onChange(of: endDate) { _ in showEndDatePicker = false }
                  }

                  // Picker de pasajeros
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
                  .sheet(isPresented: $showPassengerPicker) {
                      VStack {
                          Text("Selecciona los pasajeros").font(.headline).padding()

                          HStack {
                              Text("Adultos: \(adults)")
                              Stepper("", value: $adults, in: 1...10).labelsHidden()
                          }.padding()

                          HStack {
                              Text("Niños: \(children)")
                              Stepper("", value: $children, in: 0...10).labelsHidden()
                          }.padding()

                          Button("Aceptar") {
                              showPassengerPicker = false
                          }
                          .padding()
                          .background(Color.blue)
                          .foregroundColor(.white)
                          .cornerRadius(8)
                      }
                      .padding()
                  }

                  // MARK: Navegación condicional
                  NavigationLink(
                      destination: FlightView(
                          origin: originQuery,
                          destination: searchQuery,
                          departureDate: formatDateForAPI(startDate),
                          returnDate: formatDateForAPI(endDate)
                      ),
                      isActive: $navigateToFlights
                  ) { EmptyView() }

                  NavigationLink(
                      destination: HotelListView(
                          startDate: startDate,
                          endDate: endDate,
                          destination: searchQuery
                      ),
                      isActive: $navigateToHotelList
                  ) { EmptyView() }

                  // Botón Buscar
                  Button(action: {
                      switch selectedOption {
                      case .hotel:
                          navigateToHotelList = true
                      case .flight:
                          navigateToFlights = true
                      case .hotelFlight:
                          navigateToFlights = true
                          // Si deseas navegar a HotelListView tras ver vuelos,
                          // deberías manejar esta lógica dentro de FlightView o usar un coordinator.
                      }
                  }) {
                      Text("Buscar")
                          .foregroundColor(.white)
                          .padding()
                          .frame(maxWidth: .infinity)
                          .background(Color.blue)
                          .cornerRadius(8)
                  }
              }
              .padding()
              .background(Color(hex: "#363c46").opacity(0.9))
              .cornerRadius(12)
          }
      }

      // MARK: - Funciones auxiliares

      private func travelOptionButton(icon: String, secondIcon: String? = nil, option: TravelOption) -> some View {
          Button(action: { selectedOption = option }) {
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
          Button(action: { showPicker.wrappedValue.toggle() }) {
              HStack {
                  Image(systemName: "calendar").foregroundColor(Color(hex: "#f8be77"))
                  Text("\(title): \(formattedDate(date.wrappedValue))")
                      .foregroundColor(.white)
              }
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.white.opacity(0.2))
              .cornerRadius(8)
          }
      }

      private func formattedDate(_ date: Date) -> String {
          let formatter = DateFormatter()
          formatter.dateStyle = .medium
          return formatter.string(from: date)
      }

      private func formatDateForAPI(_ date: Date) -> String {
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          return formatter.string(from: date)
      }
  }

  #Preview {
      SearchHeaderView(searchQuery: .constant(""))
  }
