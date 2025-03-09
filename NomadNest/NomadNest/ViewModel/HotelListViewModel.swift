//
//  HotelListViewModel.swift
//  NomadNest
//
//  Created by Rocio Martos on 9/3/25.
//

import SwiftUI
import CoreLocation

class HotelListViewModel: ObservableObject {
    @Published var hotels: [Place] = []
    @Published var isLoading = false
    
    
    /// Carga los hoteles obteniendo primero las coordenadas de la ciudad
    func loadHotels(for destination: String) {
        isLoading = true
        NetworkService.shared.fetchCoordinates(for: destination) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let location):
                self.fetchNearbyHotels(location: location)
            case .failure(let error):
                print("❌ Error obteniendo coordenadas: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    

    /// Obtiene los hoteles cercanos y genera las URLs de las imágenes
    private func fetchNearbyHotels(location: CLLocationCoordinate2D) {
        NetworkService.shared.fetchNearbyPlaces(type: "hotel", location: location) { [weak self] result in
            guard let self = self else { return }
            let apiKey = NetworkService.googlePlacesAPIKey
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let places):
                    self.hotels = places.map { place in
                        var updatedPlace = place
                        
                        // Si existe al menos una foto, generamos la URL
                        if let firstPhoto = place.photos?.first {
                            // Usamos la función `getImageURL` para obtener la URL completa de la imagen
                            let imageUrl = firstPhoto.getImageURL(apiKey: apiKey)
                            
                            // Crear un nuevo objeto `Photo` con la URL completa
                            updatedPlace.photos = [Photo(
                                photo_reference: firstPhoto.photo_reference,
                                height: firstPhoto.height,
                                width: firstPhoto.width,
                                html_attributions: firstPhoto.html_attributions
                            )]
                        }
                        
                        return updatedPlace
                    }
                case .failure(let error):
                    print("❌ Error obteniendo hoteles: \(error.localizedDescription)")
                }
            }
        }
    }
}
