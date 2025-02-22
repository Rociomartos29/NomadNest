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
    
    var body: some View {
        VStack(spacing: 10) {
            // Contenedor con fondo oscuro y esquinas redondeadas
            VStack(spacing: 10) {
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
                    // Fecha de inicio
                    Button(action: {
                        showStartDatePicker.toggle()
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(hex: "#f8be77"))
                            Text("Inicio: \(formattedDate(startDate))")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .sheet(isPresented: $showStartDatePicker) {
                        DatePicker("Selecciona una fecha de inicio", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                    }
                    
                    // Fecha de fin
                    Button(action: {
                        showEndDatePicker.toggle()
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(hex: "#f8be77"))
                            Text("Fin: \(formattedDate(endDate))")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .sheet(isPresented: $showEndDatePicker) {
                        DatePicker("Selecciona una fecha de fin", selection: $endDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                    }
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
                .sheet(isPresented: $showPassengerPicker) {
                    PassengerPickerView(adults: $adults, children: $children)
                }
                
            }
            .padding()
            .background(Color(hex: "#363c46").opacity(0.9))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    // Formateo de fecha en formato corto (ej: 10 Feb 2025)
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// Vista de selección de pasajeros
struct PassengerPickerView: View {
    @Binding var adults: Int
    @Binding var children: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Selecciona el número de pasajeros")
                .font(.headline)
            
            Stepper("Adultos: \(adults)", value: $adults, in: 1...10)
            Stepper("Niños: \(children)", value: $children, in: 0...10)
            
            Button("Cerrar") {
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    SearchHeaderView(searchQuery: .constant(""))
}
