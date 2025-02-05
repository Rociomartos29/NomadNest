//
//  SearchHeaderView.swift
//  NomadNest
//
//  Created by Rocio Martos on 5/2/25.
//

import SwiftUI

struct SearchHeaderView: View {
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var passengers = 1
    
    var body: some View {
        VStack {
            // Caja de búsqueda
            VStack {
                // Campo de búsqueda de destino
                HStack {
                    TextField("Buscar destino...", text: $destination)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .foregroundColor(Color(hex: "#363c46"))
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#579f9c"), lineWidth: 1)
                        )
                    
                    Button(action: {
                        print("Buscar destino")
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: "#f8be77"))
                            .clipShape(Circle())
                    }
                }
                .padding(.top)
                
                // Selector de fechas y pasajeros
                HStack {
                    VStack(alignment: .leading) {
                        Text("Fecha de inicio")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#f8be77"))
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "#579f9c"), lineWidth: 1)
                            )
                    }
                    .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text("Fecha de fin")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#f8be77"))
                        DatePicker("", selection: $endDate, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "#579f9c"), lineWidth: 1)
                            )
                    }
                    .padding(.trailing)
                }
                .padding(.top)
                
                // Selector de pasajeros
                VStack(alignment: .leading) {
                    Text("Pasajeros")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#f8be77"))
                    Picker("Pasajeros", selection: $passengers) {
                        ForEach(1..<11) { num in
                            Text("\(num) \(num == 1 ? "pasajero" : "pasajeros")").tag(num)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Estilo de menú
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "#579f9c"), lineWidth: 1)
                    )
                }
                .padding(.top)
            }
            .padding()
            .background(Color(hex: "#363c46"))
            .cornerRadius(12)
            .shadow(radius: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "#f8ede1"), lineWidth: 2)
            )
            .padding(.horizontal)
        }
        .padding(.top)
    }
}


#Preview {
    SearchHeaderView()
}
