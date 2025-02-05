//
//  LogiView.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel() // Vinculamos el ViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                // Imagen de fondo
                Image("fondo") // Asegúrate de tener la imagen llamada "fondo" en tus assets
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all) // Asegura que la imagen cubra toda la pantalla
                
                // Contenido principal
                VStack {
                    Spacer()
            
                    
                    // Contenido de login en la parte inferior
                    VStack {
                        // Campo de email
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .keyboardType(.emailAddress)
                            .cornerRadius(8)
                          
                        
                        // Campo de password
                        SecureField("Contraseña", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white.opacity(0))
                            .cornerRadius(8)
                            
                        
                        // Botón de login
                        Button("Iniciar sesión") {
                            viewModel.login()
                        }
                        .padding()
                        .background(Color(hex: "#f8be77"))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        
                        // Mensaje de error o éxito
                        Text(viewModel.responseMessage)
                            .foregroundColor(viewModel.responseMessage.contains("Error") ? .red : .green)
                            .padding(.top, 10)
                        
                        // Navegación al registro
                        NavigationLink(destination: RegisterView(), label: {
                            Text("¿No tienes cuenta? Regístrate")
                                .foregroundColor(Color(hex: "#f8be77"))
                                .padding(.top, -10)
                        })
                       
                        
                        // Navegar a la pantalla de Explore cuando login es exitoso
                        NavigationLink(destination: ExploreView(), isActive: $viewModel.isLoggedIn) {
                            EmptyView()
                        }
                        .padding(.top, 30)
                    }
                    
                    .padding()
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                }
            }
        }
    }
}
#Preview {
    LoginView()
}
