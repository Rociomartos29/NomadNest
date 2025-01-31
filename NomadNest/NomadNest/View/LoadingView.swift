//
//  LoadingView.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import SwiftUI

struct LoadingView: View {
    @StateObject private var viewModel = LoadingViewModel()
    @State private var isLoadingComplete = false  // Nuevo estado para controlar la navegación
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Imagen de fondo
                Image("fondo") 
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all) // Hace que la imagen cubra toda la pantalla
                
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
                    
                    // Usamos NavigationLink para navegar a LoginView cuando la carga se complete
                    NavigationLink(destination: LoginView(), isActive: $isLoadingComplete) {
                        EmptyView() // No queremos que el enlace se vea, solo queremos que navegue
                    }
                }
                .onAppear {
                    viewModel.startLoading()  // Iniciar la carga cuando la vista aparece
                }
                .onChange(of: viewModel.isLoading) { newValue in
                    if !newValue {
                        // Cuando la carga se complete, se activa la navegación
                        isLoadingComplete = true
                    }
                }
            }
        }
    }
}



#Preview {
    LoadingView()
}

