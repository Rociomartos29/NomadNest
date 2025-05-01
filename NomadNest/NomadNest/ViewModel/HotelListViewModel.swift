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
    
    private let priceRange: ClosedRange<Double> = 40...200  // Rango de precios
    
    /// Carga los hoteles obteniendo primero las coordenadas de la ciudad
    func loadHotels(for destination: String) {
        isLoading = true
        NetworkService.shared.fetchCoordinates(for: destination) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let location):
                self.fetchNearbyHotels(location: location, destination: destination)
            case .failure(let error):
                print("❌ Error obteniendo coordenadas: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    /// Obtiene los hoteles cercanos, filtra solo los hoteles y genera las URLs de las imágenes
    private func fetchNearbyHotels(location: CLLocationCoordinate2D, destination: String) {
        NetworkService.shared.fetchNearbyPlaces(type: "hotel", location: location) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let places):
                    // Imprimir el número de lugares obtenidos
                    print("Se han encontrado \(places.count) lugares.")
                    
                    self.hotels = places
                        .filter { $0.types?.contains("lodging") ?? false } // Solo incluir hoteles
                        .map { place in
                            var updatedPlace = place
                            
                            // Asignar imagen si tiene
                            if let firstPhoto = place.photos?.first {
                                updatedPlace.photos = [Photo(
                                    photo_reference: firstPhoto.photo_reference,
                                    height: firstPhoto.height,
                                    width: firstPhoto.width,
                                    html_attributions: firstPhoto.html_attributions
                                )]
                            }
                            
                            // Verificar si ya tenemos un precio guardado para este hotel
                            if let storedPrice = self.getStoredPrice(for: updatedPlace.id), storedPrice > 0 {
                                updatedPlace.pricePerNight = storedPrice
                                print("Precio almacenado para \(updatedPlace.name): €\(storedPrice)")
                            } else {
                                // Si no lo tenemos, asignar un precio aleatorio entre 40$ y 200$ por noche
                                let randomPrice = Double(Int.random(in: 40...200))  // Precio entre 40 y 200
                                updatedPlace.pricePerNight = randomPrice
                                self.savePrice(for: updatedPlace.id, price: randomPrice)
                                print("Precio asignado a \(updatedPlace.name): €\(randomPrice)")
                            }
                            
                            return updatedPlace
                        }
                    
                    // Imprimir los precios asignados para depurar
                    for hotel in self.hotels {
                        if let price = hotel.pricePerNight {
                            print("Hotel: \(hotel.name), Precio por noche: €\(price)")
                        }
                    }
                    
                case .failure(let error):
                    print("❌ Error obteniendo hoteles: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Guardar el precio del hotel en UserDefaults
    private func savePrice(for hotelId: String, price: Double) {
        // Guardamos el precio en UserDefaults
        UserDefaults.standard.set(price, forKey: "price_\(hotelId)")
        
        // Verificamos que el precio haya sido guardado correctamente
        if let savedPrice = UserDefaults.standard.value(forKey: "price_\(hotelId)") as? Double {
            print("Precio guardado correctamente para \(hotelId): €\(savedPrice)")
        } else {
            print("❌ No se pudo guardar el precio para \(hotelId).")
        }
    }
    
    // Obtener el precio del hotel desde UserDefaults
    private func getStoredPrice(for hotelId: String) -> Double? {
        let price = UserDefaults.standard.double(forKey: "price_\(hotelId)")
        if price == 0 {
            print("No se encontró precio almacenado para \(hotelId).")
        }
        return price
    }
}
