//
//  LoadingView.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import SwiftUI

struct LoadingView: View {
    @StateObject private var viewModel = LoadingViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Cargando...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                Text("Carga completada")
                    .font(.largeTitle)
                    .padding()
            }
        }
        .onAppear {
            viewModel.startLoading()  // Iniciar la carga cuando la vista aparece
        }
    }
}

#Preview {
    LoadingView()
}

