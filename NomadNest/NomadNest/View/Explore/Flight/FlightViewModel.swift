//
//  FlightViewModel.swift
//  NomadNest
//
//  Created by Rocio Martos on 23/2/25.
//

import Foundation
import Combine

class FlightViewModel: ObservableObject {
    
    @Published var flights: [Flight] = []  // Lista de vuelos a mostrar en la vista
    @Published var isLoading: Bool = false  // Indica si se está cargando
    @Published var errorMessage: String?  // Mensaje de error en caso de fallar
    
    private var cancellables = Set<AnyCancellable>()
    
    // Método para obtener el token de Amadeus y buscar vuelos
    func searchFlights(from origin: String, to destination: String, departureDate: String, returnDate: String) {
        self.isLoading = true  // Activar indicador de carga
        
        // Paso 1: Obtener el token de Amadeus
        NetworkService.shared.getAmadeusAccessToken { [weak self] token, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = "Error al obtener el token de acceso: \(error.localizedDescription)"
                self.isLoading = false
                return
            }
            
            guard let token = token else {
                self.errorMessage = "No se pudo obtener el token de acceso"
                self.isLoading = false
                return
            }
            
            // Paso 2: Buscar vuelos con el token
            self.fetchFlights(token: token, origin: origin, destination: destination, departureDate: departureDate, returnDate: returnDate)
        }
    }
    
    // Método para realizar la búsqueda de vuelos usando el token de acceso
    private func fetchFlights(token: String, origin: String, destination: String, departureDate: String, returnDate: String) {
        NetworkService.shared.fetchFlights(token: token, origin: origin, destination: destination, departureDate: departureDate, returnDate: returnDate) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let flightResponse):
                // Verificar que la respuesta contenga vuelos
                if !flightResponse.data.isEmpty {
                    self.flights = flightResponse.data
                    self.errorMessage = nil
                    
                    // 🔹 Imprimir en consola para verificar los datos recibidos
                    print("✅ Datos recibidos de la API:")
                    for flight in self.flights {
                        print("✈️ \(flight.source) -> \(flight.destination) | Precio: \(flight.price.total) \(flight.price.currency)")
                    }
                } else {
                    self.errorMessage = "No se encontraron vuelos"
                    print("❌ No se encontraron vuelos.")
                }
                
            case .failure(let error):
                self.errorMessage = "Error al obtener los vuelos: \(error.localizedDescription)"
                
                // 🔹 Imprimir error en consola
                print("❌ Error al obtener vuelos:", error.localizedDescription)
            }
        }
    }
}
