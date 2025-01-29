//
//  RegisterView.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var responseMessage = ""
    @State private var isRegistered = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Campo de nombre
                TextField("Nombre", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Campo de apellidos
                TextField("Apellidos", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Campo de email
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.emailAddress)
                
                // Campo de password
                SecureField("Contraseña", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Botón de registro
                Button("Registrar") {
                    // Llamada a la API para hacer el registro
                    NetworkService.shared.register(username: email, password: password, firstName: firstName, lastName: lastName) { result in
                        switch result {
                        case .success(let response):
                            if let message = response["message"] as? String, message == "Usuario registrado" {
                                self.isRegistered = true
                            } else {
                                self.responseMessage = "Error al registrar el usuario"
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
                
                // Navegar a la pantalla de TripList cuando el registro es exitoso
                NavigationLink(destination: TripListView(), isActive: $isRegistered) {
                    EmptyView()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
#Preview {
    RegisterView()
}
