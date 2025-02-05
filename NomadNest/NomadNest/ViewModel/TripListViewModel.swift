//
//  TripListViewModel.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import Foundation

/*class TripListViewModel: ObservableObject {
    @Published var trips: [DestinationSuggestion] = []
    @Published var isLoading: Bool = false
    private let username = "rociomartos"  // Sustituye con tu nombre de usuario de GeoNames

    // Función para obtener los destinos
    func fetchTrips() {
        isLoading = true

        let urlString = "http://api.geonames.org/wikipediaSearch?search=Paris&maxRows=5&username=\(username)"
        
        // Convierte la URL a un objeto URL
        if let url = URL(string: urlString) {
            // Crea una solicitud URLSession
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Manejo de errores
                if let error = error {
                    print("Error en la solicitud: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }
                
                // Asegúrate de que recibimos datos
                guard let data = data else {
                    print("No se recibieron datos.")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }
                
                // Intentar parsear el JSON recibido
                do {
                    // Decodificar el JSON a un objeto
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(GeoNamesResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.trips = response.geonames
                        self.isLoading = false
                    }
                    
                } catch {
                    print("Error al decodificar el JSON: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            }
            
            task.resume()
        } else {
            print("URL no válida")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}

*/
