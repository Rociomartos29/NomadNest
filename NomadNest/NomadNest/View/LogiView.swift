//
//  LogiView.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isNavigatingToRegister = false
    @State private var isLoggedIn = false
    @State private var responseMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Campo de email
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.emailAddress)
                
                // Campo de password
                SecureField("Contraseña", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Botón de login
                Button("Iniciar sesión") {
                    // Llamada a la API para hacer el login
                    NetworkService.shared.login(username: email, password: password) { result in
                        switch result {
                        case .success(let response):
                            if let message = response["message"] as? String, message == "Login exitoso" {
                                self.isLoggedIn = true
                            } else {
                                self.responseMessage = "Credenciales incorrectas"
                            }
                        case .failure(let error):
                            self.responseMessage = "Error: \(error.localizedDescription)"
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                // Mensaje de error o éxito
                Text(responseMessage)
                    .foregroundColor(responseMessage.contains("Error") ? .red : .green)
                    .padding()
                
                // Navegación al registro
                NavigationLink(destination: RegisterView(), isActive: $isNavigatingToRegister) {
                    Text("¿No tienes cuenta? Regístrate")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                // Navegar a la pantalla de TripList cuando login es exitoso
                NavigationLink(destination: TripListView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                
                Spacer()
            }
            
            .padding()
        }
    }
}
#Preview {
    LoginView()
}
