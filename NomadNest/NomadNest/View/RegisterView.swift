//
//  RegisterView.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var username = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistered = false // Estado para saber si el registro fue exitoso
    @State private var errorMessage: String? = nil // Para mostrar un error si el registro falla
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: registerAction) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Si está registrado, navegar a la siguiente vista
                NavigationLink(
                    destination: ExploreView(),
                    isActive: $isRegistered
                ) {
                    EmptyView() // Ocultar el botón de navegación, ya que lo estamos controlando programáticamente
                }
            }
            .navigationTitle("Register")
            .padding()
        }
    }
    
    func registerAction() {
        // Verificar si los campos no están vacíos
        guard !username.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Todos los campos son obligatorios."
            return
        }
        
        NetworkService.shared.register(username: username, password: password, firstName: email, lastName: lastName) { result in
            switch result {
            case .success(let response):
                print("Registro exitoso: \(response)")
                // Si el registro es exitoso, cambiar el estado
                self.isRegistered = true
            case .failure(let error):
                print("Error al hacer registro: \(error.localizedDescription)")
                self.errorMessage = "Hubo un error al registrar el usuario. Inténtalo de nuevo."
            }
        }
    }
}
#Preview {
    RegisterView()
}
