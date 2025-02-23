//
//  LogiView.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import SwiftUI
import KeychainSwift

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel() // Vinculamos el ViewModel
    @AppStorage("rememberMe") private var rememberMe = false // Guarda la preferencia del usuario
    @AppStorage("savedEmail") private var savedEmail: String? // Guardar el email para recordar
    private let keychain = KeychainSwift() // Usamos KeychainSwift para manejar el token
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Imagen más pequeña en la parte superior
                Image("fondo1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 350) // Reducimos la altura de la imagen
                    .padding(.top, 50)
                
                Spacer()
                
                // Elementos alineados y sin contenedor
                VStack(spacing: 15) {
                    // Campo de email con borde de color #f8be77
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#f8be77"), lineWidth: 1) // Borde de color #f8be77
                        )
                    
                    // Campo de contraseña con borde de color #f8be77
                    SecureField("Contraseña", text: $viewModel.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#f8be77"), lineWidth: 1) // Borde de color #f8be77
                        )
                    
                    // Opción de "Recordarme"
                    Toggle(isOn: $rememberMe) {
                        Text("Recordarme")
                            .foregroundColor(Color(hex: "#f8be77"))
                    }
                    .padding(.horizontal)
                    
                    // Botón de login
                    Button("Iniciar sesión") {
                        viewModel.login() // Realiza el login
                        if viewModel.isLoggedIn {
                            if rememberMe {
                                // Guardar el email en UserDefaults
                                UserDefaults.standard.set(viewModel.email, forKey: "savedEmail")
                                
                                // El token ya se guarda automáticamente en Keychain en NetworkService
                            }
                        } else {
                            // Mostrar mensaje de error en caso de que no sea exitoso
                            viewModel.responseMessage = "Credenciales incorrectas"
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#f8be77"))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    
                    // Mensaje de error o éxito
                    Text(viewModel.responseMessage)
                        .foregroundColor(viewModel.responseMessage.contains("Error") ? .red : .green)
                        .padding(.top, 10)
                    
                    // Enlace a la pantalla de registro
                    NavigationLink(destination: RegisterView()) {
                        Text("¿No tienes cuenta? Regístrate")
                            .foregroundColor(Color(hex: "#f8be77"))
                    }
                    
                    // Navegar a ExploreView tras login exitoso
                    NavigationLink(destination: ExploreView(), isActive: $viewModel.isLoggedIn) {
                        EmptyView()
                    }
                    .padding(.top, 30)
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .background(Color.white.ignoresSafeArea())
            .onAppear {
                // Verificar si ya hay un token guardado al iniciar
                viewModel.checkSession() // Esto verificará si el usuario ya está logueado
                // Cargar el email guardado si existe
                if let savedEmail = UserDefaults.standard.string(forKey: "savedEmail") {
                    viewModel.email = savedEmail
                    rememberMe = true
                }
            }
        }
    }
}
#Preview {
    LoginView()
}
