//
//  RegisterView.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel() // Vinculamos el ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Campos de entrada
                TextField("Nombre", text: $viewModel.nombre)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Apellido", text: $viewModel.apellido)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Contraseña", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Botón de registro
                Button(action:{
                    print("Botón de registro presionado. Datos que se enviarán:")
                    print("Nombre: \(viewModel.nombre), Apellido: \(viewModel.apellido), Email: \(viewModel.email), Contraseña: \(viewModel.password)")
                    viewModel.register()
                })  {
                 
                    Text("Registrarse")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                // Mostrar mensaje de error o éxito si no está vacío
                if !viewModel.responseMessage.isEmpty {
                    Text(viewModel.responseMessage)
                        .foregroundColor(viewModel.isError ? .red : .green)
                        .padding()
                }
                // Navegación a ExploreView si el registro es exitoso
                NavigationLink(
                    destination: ExploreView(),
                    isActive: $viewModel.isRegistered
                ) {
                    EmptyView()
                }
            }
            .navigationTitle("Registro")
            .padding()
        }
    }
}
#Preview {
    RegisterView()
}
