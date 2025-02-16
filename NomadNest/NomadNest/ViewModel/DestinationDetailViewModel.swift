//
//  DestinationDetailViewModel.swift
//  NomadNest
//
//  Created by Rocio Martos on 16/2/25.
//


import Combine
import CoreLocation

class DestinationsDetailViewModel: ObservableObject {
    @Published var hotels: [Place] = []
    @Published var restaurants: [Place] = []
    @Published var activities: [Place] = []
    @Published var isLoading: Bool = false
    
    func fetchPlaces(for destination: Destination) {
        isLoading = true
        
        // Obtener coordenadas de la ciudad de destino
        getCoordinates(for: destination.title) { location in
            guard let location = location else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            // Obtener hoteles cercanos
            dispatchGroup.enter()
            NetworkService.shared.fetchNearbyPlaces(type: "hotel", location: location) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let places):
                        // Obtener imágenes para cada lugar
                        self.hotels = places.map { place in
                            var placeWithPhotos = place
                            self.fetchPlaceImages(for: placeWithPhotos)
                            return placeWithPhotos
                        }
                    case .failure(let error):
                        print("Error obteniendo hoteles: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            // Obtener restaurantes cercanos
            dispatchGroup.enter()
            NetworkService.shared.fetchNearbyPlaces(type: "restaurant", location: location) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let places):
                        // Obtener imágenes para cada lugar
                        self.restaurants = places.map { place in
                            var placeWithPhotos = place
                            self.fetchPlaceImages(for: placeWithPhotos)
                            return placeWithPhotos
                        }
                    case .failure(let error):
                        print("Error obteniendo restaurantes: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            // Obtener actividades cercanas
            dispatchGroup.enter()
            NetworkService.shared.fetchNearbyPlaces(type: "tourist_attraction", location: location) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let places):
                        // Obtener imágenes para cada lugar
                        self.activities = places.map { place in
                            var placeWithPhotos = place
                            self.fetchPlaceImages(for: placeWithPhotos)
                            return placeWithPhotos
                        }
                    case .failure(let error):
                        print("Error obteniendo actividades: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            // Esperar a que todas las solicitudes terminen
            dispatchGroup.notify(queue: .main) {
                self.isLoading = false
            }
        }
    }
    
    // Obtener coordenadas para una ciudad
    private func getCoordinates(for city: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        NetworkService.shared.fetchCoordinates(for: city) { result in
            switch result {
            case .success(let location):
                completion(location)
            case .failure(let error):
                print("Error obteniendo coordenadas: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    // Obtener imágenes para cada lugar
    private func fetchPlaceImages(for place: Place) {
        // Hacemos una copia del lugar
        var placeCopy = place
        
        if let photoReference = placeCopy.photos?.first?.photo_reference {
            // Si tiene fotos, obtenemos la URL de la imagen
            NetworkService.shared.fetchImageURL(for: photoReference) { result in
                switch result {
                case .success(let imageURL):
                    // Crear un nuevo objeto Photo con la URL obtenida
                    let photo = Photo(photo_reference: imageURL, height: 0, width: 0, html_attributions: []) // Pasamos un array vacío para html_attributions
                    // Asignar el nuevo array con el objeto Photo al lugar
                    placeCopy.photos = [photo]
                    
                    // Actualizamos la propiedad 'photos' en el lugar original, fuera de la clausura
                    DispatchQueue.main.async {
                        if let index = self.hotels.firstIndex(where: { $0.id == place.id }) {
                            self.hotels[index].photos = placeCopy.photos
                        }
                        if let index = self.restaurants.firstIndex(where: { $0.id == place.id }) {
                            self.restaurants[index].photos = placeCopy.photos
                        }
                        if let index = self.activities.firstIndex(where: { $0.id == place.id }) {
                            self.activities[index].photos = placeCopy.photos
                        }
                    }
                case .failure(let error):
                    print("Error obteniendo imagen para el lugar: \(error.localizedDescription)")
                }
            }
        }
    }
}
