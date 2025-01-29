//
//  TripListView.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import SwiftUI

struct TripListView: View {
    @StateObject private var viewModel = TripListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.trips) { trip in
                VStack(alignment: .leading) {
                    Text(trip.title)
                        .font(.headline)
                    Text(trip.summary)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Mis Viajes")
            .onAppear {
                viewModel.fetchTrips()  // Cargar destinos cuando la vista aparezca
            }
        }
    }
}

#Preview {
    TripListView()
}
