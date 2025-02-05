//
//  SuggestionViewModel.swift
//  NomadNest
//
//  Created by Rocio Martos on 30/1/25.
//

import SwiftUI
import Combine

class SuggestionViewModel: ObservableObject {
    @Published var destinations: [Destination] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    // Función para obtener destinos con el completion handler
    func fetchDestinations(completion: @escaping (Result<[Destination], Error>) -> Void) {
        self.isLoading = true
        self.errorMessage = nil
        
        // URL del servidor con los destinos
        let url = URL(string: "http://localhost:4000/destinations")!
        
        // Crear la solicitud HTTP
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Ejecutar la tarea de red
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    self.isLoading = false
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                    self.isLoading = false
                }
                return
            }
            
            print("Datos recibidos de la respuesta al obtener destinos: \(String(describing: String(data: data, encoding: .utf8)))")
            
            do {
                // Decodificar la respuesta JSON
                let destinationsResponse = try JSONDecoder().decode(DestinationsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.destinations = destinationsResponse.destinations
                    self.isLoading = false
                    completion(.success(destinationsResponse.destinations))
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error al decodificar los datos de los destinos: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError))
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

extension SuggestionViewModel {
    static func mockedInstance() -> SuggestionViewModel {
        let viewModel = SuggestionViewModel()
        
        // Agregar destinos simulados para pruebas sin conexión
        viewModel.destinations = [
            Destination(id: 1, title: "Nueva Zelanda", country: "Nueva Zelanda", description: "Un paraíso para los aventureros con actividades como el bungee jumping, rafting y senderismo en paisajes de otro mundo", category: "Aventura", imageUrl: "https://images.app.goo.gl/MTUhzGMUYaobNai78")
        ]
                           
        return viewModel
    }
}
