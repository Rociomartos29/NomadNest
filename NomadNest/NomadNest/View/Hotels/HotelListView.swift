//
//  HotelListView.swift
//  NomadNest
//
//  Created by Rocio Martos on 9/3/25.
//

import SwiftUI

struct HotelListView: View {
    var startDate: Date
    var endDate: Date
    var destination: String
    
    @StateObject private var viewModel = HotelListViewModel()
    @State private var selectedHotel: Place? = nil
    @State private var showReservationSheet = false
    
    private var numberOfNights: Int {
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.day], from: startDate, to: endDate)
        return difference.day ?? 1
    }
    
    var body: some View {
        VStack {
            Text("Hoteles en \(destination)")
                .font(.title)
                .bold()
                .padding(.top)
            
            if viewModel.isLoading {
                ProgressView("Cargando hoteles...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                if viewModel.hotels.isEmpty {
                    VStack {
                        Image(systemName: "bed.double.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        
                        Text("No se encontraron hoteles en \(destination).")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.hotels, id: \.id) { hotel in
                                Button {
                                    selectedHotel = hotel
                                    showReservationSheet = true
                                } label: {
                                    HotelRowView(
                                        viewModel: viewModel,
                                        hotel: hotel,
                                        numberOfNights: numberOfNights
                                    )
                                    .padding(.horizontal, 16)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Hoteles")
        .onAppear {
            viewModel.loadHotels(for: destination)
        }
        .sheet(isPresented: $showReservationSheet) {
            if let hotel = selectedHotel {
                HotelReservationSheetView(
                    hotel: hotel,
                    startDate: startDate,
                    endDate: endDate
                )
            }
        }
    }
}

#Preview {
    HotelListView(
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400),
        destination: "Madrid"
    )
}
