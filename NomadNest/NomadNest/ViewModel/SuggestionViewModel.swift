//
//  SuggestionViewModel.swift
//  NomadNest
//
//  Created by Rocio Martos on 30/1/25.
//

import SwiftUI
import Combine

class SuggestionViewModel: ObservableObject {
    @Published var destinations: [DestinationSuggestion] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let baseURL = "https://www.dataestur.es/api/datos-turismo"
    
    func fetchDestinations() {
        guard let url = URL(string: "\(baseURL)/destinos-turisticos") else {
            print("URL inválida")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [DestinationSuggestion].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error al obtener destinos: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] suggestions in
                print("Destinos obtenidos: \(suggestions)")  // Asegúrate de ver los destinos aquí
                self?.destinations = suggestions
            })
            .store(in: &cancellables)
    }
}
extension SuggestionViewModel {
    static func mockedInstance() -> SuggestionViewModel {
        let viewModel = SuggestionViewModel()

        // Agregamos destinos simulados con todos los parámetros
        viewModel.destinations = [
            DestinationSuggestion(city: "Madrid", country: "España", description: "Capital de España", category: "Cultura", imageURL: "https://link_a_imagen.jpg"),
            DestinationSuggestion(city: "Lisboa", country: "Portugal", description: "Capital de Portugal", category: "Cultura", imageURL: "https://link_a_imagen.jpg"),
            DestinationSuggestion(city: "París", country: "Francia", description: "Capital de Francia", category: "Cultura", imageURL: "https://link_a_imagen.jpg")
        ]

        return viewModel
    }
}
