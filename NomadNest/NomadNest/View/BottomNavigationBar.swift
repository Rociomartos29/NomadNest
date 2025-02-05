//
//  BottomNavigationBar.swift
//  NomadNest
//
//  Created by Rocio Martos on 5/2/25.
//

import SwiftUI

struct BottomNavigationBar: View {
    var body: some View {
        HStack {
            // Lupa (Explorar)
            NavigationLink(destination: ExploreView()) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color(hex: "#f8be77")))
            }
            
            // Corazón (Favoritos)
            NavigationLink(destination: TripListView()) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color(hex: "#f8be77")))
            }
            
            // Maleta (Reservas)
            NavigationLink(destination: ReservationsView()) {
                Image(systemName: "suitcase.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color(hex: "#f8be77")))
            }
            
            // Usuario (Ajustes)
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color(hex: "#f8be77")))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "#363c46"))
        .cornerRadius(20)
        
    }
}


#Preview {
    BottomNavigationBar()
}
