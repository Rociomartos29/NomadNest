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
       
       // Método para obtener los vuelos
       func searchFlights(from origin: String, to destination: String, departureDate: String, returnDate: String) {
           self.isLoading = true  // Activar indicador de carga
           
           // Paso 1: Llamar al servicio de red para obtener los vuelos
           fetchFlights(origin: origin, destination: destination, departureDate: departureDate, returnDate: returnDate)
       }
       
       // Método para realizar la búsqueda de vuelos usando el servicio de red
       private func fetchFlights(origin: String, destination: String, departureDate: String, returnDate: String) {
           // Llamada a la función de la API para obtener los vuelos
           NetworkService.shared.fetchFlights(origin: origin, destination: destination, departureDate: departureDate, returnDate: returnDate) { [weak self] result in
               guard let self = self else { return }
               
               self.isLoading = false
               
               switch result {
               case .success(let flights):
                   // Verificar que la respuesta contenga vuelos
                   if !flights.isEmpty {
                       self.flights = flights
                       self.errorMessage = nil
                       
                       // 🔹 Imprimir en consola para verificar los datos recibidos
                       print("✅ Datos recibidos de la API:")
                       for flight in self.flights {
                           // Cambiar de flight.price.total a flight.price directamente
                           print("✈️ \(flight.origin) -> \(flight.destination) | Precio: \(flight.price) €")
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
