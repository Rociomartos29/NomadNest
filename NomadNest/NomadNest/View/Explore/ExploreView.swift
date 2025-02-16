//
//  ExploreView.swift
//  NomadNest
//
//  Created by Rocio Martos on 30/1/25.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = SuggestionViewModel()
    @State private var userName = ""
    @State private var searchQuery = ""  // Almacena la ciudad buscada
    
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
                        
                        // Encabezado de búsqueda
                        SearchHeaderView(searchQuery: $searchQuery)  // Pasamos el binding para el texto de búsqueda
                        
                        // "Lo más destacado" y mostrar destinos
                        Text("Lo más destacado")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color(hex: "#f8be77"))
                            .padding(.top)
                        
                        // Filtrar destinos por nombre de ciudad (si se ha introducido una búsqueda)
                        let filteredDestinations = searchQuery.isEmpty ? viewModel.destinations : viewModel.destinations.filter {
                            $0.title.lowercased().contains(searchQuery.lowercased())  // Filtrado de destino por ciudad
                        }
                        
                        // Mostrar categorías si hay destinos
                        if !filteredDestinations.isEmpty {
                            ForEach(getUniqueCategories(from: filteredDestinations), id: \.self) { category in
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(category)
                                        .font(.title2)
                                        .bold()
                                        .padding(.leading)
                                        .foregroundColor(Color(hex: "#f8be77"))
                                    
                                    // Lista horizontal de destinos por categoría
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack(spacing: 16) {
                                            ForEach(filteredDestinations.filter { $0.category == category }) { destination in
                                                // Envolver DestinationCardView en un NavigationLink
                                                NavigationLink(destination: DestinationsDetailView(destination: destination)) {
                                                    DestinationCardView(destination: destination)  // Tarjeta de destino
                                                }
                                                .buttonStyle(PlainButtonStyle())  // Evitar el estilo predeterminado del botón
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
                        .padding(.bottom, 0)  // Asegura que la barra esté fija en la parte inferior
                        .frame(maxWidth: .infinity)  // Asegura que ocupe todo el ancho
                }
                .edgesIgnoringSafeArea(.bottom)  // Ignorar el área segura para la barra inferior
            }
            .navigationBarHidden(true) // Esto oculta la barra de navegación superior
        }
    }
    
    // Obtener categorías únicas de los destinos
    private func getUniqueCategories(from destinations: [Destination]) -> [String] {
        Set(destinations.map { $0.category }).sorted()  // Obtiene las categorías únicas de los destinos filtrados
    }
}
#Preview {
    ExploreView()
        .environmentObject(SuggestionViewModel.mockedInstance())
}


