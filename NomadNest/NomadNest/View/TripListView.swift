//
//  TripListView.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import SwiftUI

struct TripListView: View {
    let categories = [
        ("Escapadas Románticas", [
            Destinations(name: "París", description: "La ciudad del amor", image: "paris"),
            Destinations(name: "Venecia", description: "Canales y encanto", image: "venecia")
        ]),
        ("Playas Increíbles", [
            Destinations(name: "Maldivas", description: "Playas de arena blanca", image: "maldivas"),
            Destinations(name: "Bali", description: "Paraíso tropical", image: "bali")
        ]),
        ("Aventura en Montaña", [
            Destinations(name: "Alpes Suizos", description: "Esquí y paisajes increíbles", image: "alpes"),
            Destinations(name: "Montañas Rocosas", description: "Naturaleza salvaje", image: "rocosas")
        ])
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Destinos sugeridos")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()

                ForEach(categories, id: \.0) { category, destinations in
                    VStack(alignment: .leading) {
                        Text(category)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        ForEach(destinations) { destination in
                            DestinationRow(destination: destination)
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .background(Color("Background").edgesIgnoringSafeArea(.all))
    }
}

struct DestinationRow: View {
    let destination: Destinations

    var body: some View {
        HStack {
            Image(destination.image)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 5) {
                Text(destination.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(destination.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct Destinations: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let image: String
}


#Preview {
    TripListView()
}
