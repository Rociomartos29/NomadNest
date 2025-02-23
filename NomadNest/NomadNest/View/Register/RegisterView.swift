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
                // Imagen más pequeña en la parte superior
                Image("fondo1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 350) // Reducimos la altura de la imagen
                    .padding(.top, 50)
                
                Spacer()
                // Campos de entrada
                TextField("Nombre", text: $viewModel.nombre)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "#f8be77"), lineWidth: 1) // Borde de color #f8be77
                    )
                    .padding()
                
                
                TextField("Apellido", text: $viewModel.apellido)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "#f8be77"), lineWidth: 1) // Borde de color #f8be77
                    )
                    .padding()
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "#f8be77"), lineWidth: 1) // Borde de color #f8be77
                    )
                    .padding()
                
                SecureField("Contraseña", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "#f8be77"), lineWidth: 1) // Borde de color #f8be77
                    )
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
                        .background(Color(hex: "#f8be77"))
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
            .padding()
        }
    }
}
#Preview {
    RegisterView()
}
