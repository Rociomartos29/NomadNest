//
//  ExploreView.swift
//  NomadNest
//
//  Created by Rocio Martos on 30/1/25.
//

import SwiftUI


struct ExploreView: View {
    @StateObject private var viewModel = SuggestionViewModel()
    @State private var userName: String = "Viajero" // Nombre por defecto
    @State private var searchQuery = ""  // Almacena la ciudad buscada
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo blanco en toda la pantalla
                Color.white
                    .edgesIgnoringSafeArea(.all)
                    
                // Contenido principal
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Saludo con el nombre del usuario
                        Text("Bienvenido, \(userName)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color(hex: "#f8be77"))
                            .padding(.top)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Encabezado de búsqueda
                        SearchHeaderView(searchQuery: $searchQuery)
                        
                        // "Lo más destacado" y mostrar destinos
                        Text("Lo más destacado")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color(hex: "#f8be77"))
                            .padding(.top)
                            .padding(.leading)
                        
                        // Filtrar destinos por nombre de ciudad (si se ha introducido una búsqueda)
                        let filteredDestinations = searchQuery.isEmpty ? viewModel.destinations : viewModel.destinations.filter {
                            $0.title.lowercased().contains(searchQuery.lowercased())
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
                                                NavigationLink(destination: DestinationsDetailView(destination: destination)) {
                                                    DestinationCardView(destination: destination)
                                                }
                                                .buttonStyle(PlainButtonStyle())
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
                    loadUserName()
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
                    Spacer()
                    BottomNavigationBar()
                        .padding(.bottom, 0)
                        .frame(maxWidth: .infinity)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarHidden(true)
        }
    }
    
    private func getUniqueCategories(from destinations: [Destination]) -> [String] {
        Set(destinations.map { $0.category }).sorted()
    }
    
    private func loadUserName() {
        // Suponiendo que el nombre se guarda en UserDefaults al iniciar sesión
        if let savedUserName = UserDefaults.standard.string(forKey: "userName") {
            self.userName = savedUserName
        }
    }
}

#Preview {
    ExploreView()
        .environmentObject(SuggestionViewModel.mockedInstance())
}


