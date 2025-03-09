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
    
    @StateObject private var viewModel = HotelListViewModel()  // Instancia del ViewModel
    
    // Variables @State para rastrear las selecciones del usuario
    @State private var numberOfNights: Int = 1
    @State private var numberOfPeople: Int = 1
    
    var body: some View {
        VStack {
            Text("Hoteles en \(destination)")
                .font(.title)
                .bold()
                .padding(.top)
            
            if viewModel.isLoading {
                ProgressView("Cargando hoteles...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                if viewModel.hotels.isEmpty {
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
                                HotelRowView(
                                    viewModel: viewModel,
                                    hotel: hotel,
                                    numberOfNights: numberOfNights,  // Pasamos el número de noches
                                    numberOfPeople: numberOfPeople   // Pasamos el número de personas
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Hoteles")
        .onAppear {
            // Cargar los hoteles cuando la vista aparezca
            viewModel.loadHotels(for: destination)
        }
    }
}

#Preview {
    HotelListView(
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400),
        destination: "Madrid"
    )
}
