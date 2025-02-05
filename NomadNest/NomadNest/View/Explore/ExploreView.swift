//
//  ExploreView.swift
//  NomadNest
//
//  Created by Rocio Martos on 30/1/25.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = SuggestionViewModel()
    @State private var userName = "/(user.name)"
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo oscuro general
                Color(hex: "#363c46")
                    .edgesIgnoringSafeArea(.all)
                
                // Contenido principal
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Saludo con el nombre del usuario
                        Text("Bienvenido \(userName)")  // Muestra el nombre del usuario
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color(hex: "#f8be77"))
                            .padding(.top)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Encabezado estilo búsqueda de Booking
                        SearchHeaderView()
                        
                        // "Lo más destacado" y mostrar destinos
                        Text("Lo más destacado")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color(hex: "#f8be77"))
                            .padding(.top)
                        
                        // Mostrar categorías si hay destinos
                        if !viewModel.destinations.isEmpty {
                            ForEach(getUniqueCategories(), id: \.self) { category in
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(category)
                                        .font(.title2)
                                        .bold()
                                        .padding(.leading)
                                        .foregroundColor(Color(hex: "#f8be77"))
                                    
                                    // Lista horizontal de destinos por categoría
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack(spacing: 16) {
                                            ForEach(viewModel.destinations.filter { $0.category == category }) { destination in
                                                DestinationCardView(destination: destination)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        } else if viewModel.isLoading {
                            Text("Cargando destinos...")
                                .foregroundColor(.gray)
                                .padding()
                        } else if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchDestinations { result in
                        switch result {
                        case .success(let destinations):
                            viewModel.destinations = destinations
                        case .failure(let error):
                            viewModel.errorMessage = "Error: \(error.localizedDescription)"
                        }
                    }
                }
                // Barra de navegación fija en la parte inferior
                VStack {
                    Spacer()  // Empuja la barra de navegación hacia abajo
                    BottomNavigationBar()  // Barra de navegación
                }
            }
            .navigationBarHidden(true) // Esto oculta la barra de navegación superior
        }
    }
    
    
    
    
    
    // Obtener categorías únicas de los destinos
    private func getUniqueCategories() -> [String] {
        Set(viewModel.destinations.map { $0.category }).sorted()
        
    }
}




#Preview {
    ExploreView()
        .environmentObject(SuggestionViewModel.mockedInstance())
}


