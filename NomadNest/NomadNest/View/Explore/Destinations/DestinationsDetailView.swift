//
//  DestinationsDetailView.swift
//  NomadNest
//
//  Created by Rocio Martos on 16/2/25.
//

import SwiftUI

struct DestinationsDetailView: View {
    let destination: Destination
    @StateObject private var viewModel = DestinationsDetailViewModel()
    
    var body: some View {
          ScrollView {
              VStack(alignment: .leading, spacing: 20) {
                  // Imagen principal del destino con esquinas redondeadas
                  AsyncImage(url: URL(string: destination.imageUrl)) { image in
                      image.resizable()
                          .scaledToFill()
                          .frame(height: 250)
                          .clipShape(RoundedRectangle(cornerRadius: 12)) // Bordes redondeados
                          
                  } placeholder: {
                      Color.gray.frame(height: 250)
                          .clipShape(RoundedRectangle(cornerRadius: 12))
                  }
                  
                  // Nombre del destino
                  Text(destination.title)
                      .font(.largeTitle)
                      .bold()
                      .foregroundColor(Color(hex: "#f8be77"))
                      .padding(.horizontal)
                  
                  // Descripción
                  Text(destination.description)
                      .font(.body)
                      .foregroundColor(.black)
                      .padding(.horizontal)
                  
                  // Mostrar ProgressView mientras carga
                  if viewModel.isLoading {
                      ProgressView("Cargando recomendaciones...")
                          .padding()
                  } else {
                      // Secciones de recomendaciones
                      SectionView(title: "🏨 Hoteles recomendados", places: viewModel.hotels)
                      SectionView(title: "🍽 Restaurantes recomendados", places: viewModel.restaurants)
                      SectionView(title: "🎢 Actividades y excursiones", places: viewModel.activities)
                  }
              }
          }
          .background(Color.white)
          .edgesIgnoringSafeArea(.top)
          .onAppear {
              viewModel.fetchPlaces(for: destination)
          }
      }
  }

// Componente reutilizable para las secciones con scroll horizontal
struct SectionView: View {
    let title: String
    let places: [Place]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Título de la sección
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(Color(hex: "#f8be77"))
                .padding(.horizontal)
            
            // Scroll horizontal para los lugares
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(places) { place in
                        VStack(alignment: .leading, spacing: 5) {
                            // Nombre del lugar
                            Text(place.name)
                                .font(.body)
                                .foregroundColor(.white)
                            
                            // Mostrar imagen del lugar si existe
                            if let imageUrl = place.photos?.first?.photo_reference {
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image.resizable()
                                        .scaledToFill() // Aseguramos que la imagen llene el área sin distorsionar
                                        .frame(width: 150, height: 120) // Fijamos el tamaño de las imágenes
                                        .clipped() // Recorta lo que no encaje en el frame
                                } placeholder: {
                                    Color.gray.frame(width: 150, height: 120) // Placeholder también con el mismo tamaño
                                }
                            }
                            
                            // Información adicional (ubicación)
                            if let vicinity = place.vicinity {
                                Text(vicinity)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 150, height: 200)  // Ajustamos el tamaño de las tarjetas
                        .padding(16)  // Espaciado de 16 puntos entre las tarjetas
                        .background(Color(hex: "#4e5661"))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding(.horizontal, 16)  // Aseguramos que las tarjetas tengan margen en los laterales de la pantalla
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    DestinationsDetailView(destination: Destination(
        id: 1,
        title: "Barcelona",
        country: "España",
        description: "Una ciudad vibrante con una arquitectura impresionante, playas y vida nocturna.",
        category: "Cultural",
        imageUrl: "https://example.com/barcelona.jpg"
    ))
}
