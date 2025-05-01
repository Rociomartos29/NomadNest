//
//  HotelRowView.swift
//  NomadNest
//
//  Created by Rocio Martos on 9/3/25.
//

import SwiftUI

struct HotelRowView: View {
    @ObservedObject var viewModel: HotelListViewModel
    let hotel: Place
    let numberOfNights: Int
    
    // Calcular el precio total (solo por noches)
    private var totalPrice: Double {
        let pricePerNight = hotel.pricePerNight ?? 0  // Si es nil, usa 0
        return pricePerNight * Double(numberOfNights)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Imagen del hotel (con tamaño fijo)
            if let firstPhoto = hotel.photos?.first {
                AsyncImage(url: URL(string: firstPhoto.getImageURL(apiKey: NetworkService.googlePlacesAPIKey))) { image in
                    image.resizable()
                        .scaledToFill()  // Asegura que la imagen ocupe todo el espacio disponible
                        .frame(width: UIScreen.main.bounds.width - 32, height: 180)  // Tamaño fijo para la imagen
                        .cornerRadius(10)
                        .clipped()  // Recorta la imagen si se desborda
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: UIScreen.main.bounds.width - 32, height: 180)  // Tamaño fijo para la imagen mientras se carga
                }
            }
            
            // Información del hotel
            VStack(alignment: .leading, spacing: 8) {
                // Nombre del hotel
                Text(hotel.name)
                    .font(.headline)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .foregroundColor(Color(hex: "#363c46"))
                
                // Rating del hotel
                if let rating = hotel.rating {
                    HStack {
                        Text("⭐️ \(rating, specifier: "%.1f")")
                            .font(.subheadline)
                            .foregroundColor(.yellow)
                    }
                }
                
                // Precio por noche y total
                if let pricePerNight = hotel.pricePerNight {
                    HStack {
                        Text("€\(pricePerNight, specifier: "%.2f")/noche")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#479295"))
                        Spacer()
                        Text("Total: €\(totalPrice, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#f8be77"))
                    }
                }
            }
            .padding([.horizontal, .bottom], 15)
            
            // Divider line for separation between hotels
            Divider()
                .background(Color.gray.opacity(0.3))
        }
        .background(Color.white)  // Fondo blanco
        .cornerRadius(15)  // Bordes redondeados
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)  // Sombra más difusa y elegante
        .padding(.horizontal, 16)  // Márgenes laterales ajustados a 16
        .frame(maxWidth: .infinity)  // Aseguramos que las cards tengan el mismo tamaño
    }
}

#Preview {
    let exampleHotel = Place(
        id: "1",
        name: "Hotel Ejemplo",
        vicinity: "Calle Falsa 123",
        rating: 4.5,
        types: ["hotel"],
        geometry: Geometry(location: Location(lat: 40.748817, lng: -73.985428)),
        photos: [Photo(photo_reference: "photo_reference_example", height: 300, width: 400, html_attributions: nil)],
        pricePerNight: 150.0 // Precio por noche
    )
    
    let numberOfNights = 3
    
    return HotelRowView(viewModel: HotelListViewModel(), hotel: exampleHotel, numberOfNights: numberOfNights)
}
