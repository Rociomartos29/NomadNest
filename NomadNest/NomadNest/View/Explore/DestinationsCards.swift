//
//  DestinationsCards.swift
//  NomadNest
//
//  Created by Rocio Martos on 5/2/25.
//

import SwiftUI
struct DestinationCardView: View {
    let destination: Destination
    
    var body: some View {
        VStack(alignment: .leading) {
            // Imagen con dimensiones fijas
            AsyncImage(url: URL(string: destination.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill() // Asegura que la imagen ocupe todo el espacio disponible
                    .frame(width: 200, height: 120) // Dimensiones fijas
                    .cornerRadius(12)
                    .clipped() // Recorta cualquier exceso de imagen fuera del marco
            } placeholder: {
                Color.gray // Muestra un color de fondo mientras se carga la imagen
                    .frame(width: 200, height: 120)
                    .cornerRadius(12)
            }
            
            // Título y país del destino
            Text(destination.title)
                .font(.headline)
                .foregroundColor(.white)
            Text(destination.country)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 200)
        .background(Color(hex: "#363c46")) // Fondo oscuro para las tarjetas
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}


#Preview {
    DestinationCardView(destination: Destination(
           id: 1,
           title: "Nueva Zelanda",
           country: "Nueva Zelanda",
           description: "Un paraíso para los aventureros con actividades como el bungee jumping, rafting y senderismo en paisajes de otro mundo",
           category: "Aventura",
           imageUrl: "https://images.app.goo.gl/MTUhzGMUYaobNai78"
       ))
}
