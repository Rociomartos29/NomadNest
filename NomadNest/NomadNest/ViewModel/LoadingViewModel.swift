//
//  LoadingViewModel.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import Foundation

class LoadingViewModel: ObservableObject {
    @Published var isLoading: Bool = true  // Indicador de carga

    // Simular un proceso de carga
    func startLoading() {
        // Simular un proceso que dura 3 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoading = false  // Desactivar el indicador de carga después de 3 segundos
        }
    }
}
