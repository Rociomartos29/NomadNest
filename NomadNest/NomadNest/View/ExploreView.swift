//
//  ExploreView.swift
//  NomadNest
//
//  Created by Rocio Martos on 30/1/25.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = SuggestionViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Explora Destinos")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.leading, 16)
                    
                    if viewModel.destinations.isEmpty {
                        Text("Cargando destinos...")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(viewModel.destinations) { destination in
                            DestinationCardView(destination: destination)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .background(Color("Background").edgesIgnoringSafeArea(.all))
            .onAppear {
                viewModel.fetchDestinations()
            }
        }
    }
}

struct DestinationCardView: View {
    let destination: DestinationSuggestion
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(destination.city)
                .font(.headline)
                .foregroundColor(.white)
            Text(destination.country)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

#Preview {
    ExploreView()
        .environmentObject(SuggestionViewModel.mockedInstance())
}
