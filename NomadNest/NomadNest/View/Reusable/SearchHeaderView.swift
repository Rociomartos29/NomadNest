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
    
    enum TravelOption {
        case hotel, flight, hotelFlight
    }
    
    // Usamos @State para navegar a la pantalla de HotelList
    @State private var navigateToHotelList = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                // Botones de opciones de búsqueda
                HStack(spacing: 20) {
                    travelOptionButton(icon: "bed.double.fill", option: .hotel)
                    travelOptionButton(icon: "airplane", option: .flight)
                    travelOptionButton(icon: "bed.double.fill", secondIcon: "airplane", option: .hotelFlight)
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
                
                // Caja de búsqueda para destino
                TextField("Buscar destino...", text: $searchQuery)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .onTapGesture {
                        self.isEditing = true
                    }
                    .font(.title3)
                    .foregroundColor(.black)
                    .keyboardType(.default)
                
                // Mostrar origen solo si la opción es vuelo o vuelo + hotel
                if selectedOption == .flight || selectedOption == .hotelFlight {
                    TextField("Buscar origen...", text: $originQuery)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .onTapGesture {
                            self.isEditing = true
                        }
                        .font(.title3)
                        .foregroundColor(.black)
                        .keyboardType(.default)
                }
                
                // **Las fechas siempre visibles** para todas las opciones
                HStack {
                    dateButton(title: "Inicio", date: $startDate, showPicker: $showStartDatePicker)
                    dateButton(title: "Fin", date: $endDate, showPicker: $showEndDatePicker)
                }
                
                // Mostrar el calendario solo cuando se toca el botón
                if showStartDatePicker {
                    DatePicker("", selection: $startDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .onChange(of: startDate) { newDate in
                            self.showStartDatePicker = false
                        }
                }
                
                if showEndDatePicker {
                    DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .onChange(of: endDate) { newDate in
                            self.showEndDatePicker = false
                        }
                }
                
                // Botón para mostrar selección de pasajeros
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
                
                // Botón de búsqueda que navega a la vista de HotelList
                NavigationLink(destination: HotelListView(startDate: startDate, endDate: endDate, destination: searchQuery), isActive: $navigateToHotelList) {
                    Button(action: {
                        // Cuando se pulsa el botón de búsqueda, navegamos a HotelListView
                        navigateToHotelList = true
                    }) {
                        Text("Buscar")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(Color(hex: "#363c46").opacity(0.9))
            .cornerRadius(12)
        }
    }
    private func travelOptionButton(icon: String, secondIcon: String? = nil, option: TravelOption) -> some View {
        Button(action: {
            selectedOption = option
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
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    SearchHeaderView(searchQuery: .constant(""))
}
