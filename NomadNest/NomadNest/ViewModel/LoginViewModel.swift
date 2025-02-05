//
//  LoginViewModel.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import Foundation
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var responseMessage = ""
    @Published var isLoggedIn = false
    @Published var user: User? // Almacena el usuario autenticado
    
    func login() {
        print("Intentando iniciar sesión con el correo: \(email) y la contraseña: \(password)")
        
        NetworkService.shared.login(username: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    self.isLoggedIn = true
                    self.responseMessage = "Login exitoso. ¡Bienvenido \(user.nombre)!"
                    print("Login exitoso para el usuario: \(user.nombre) \(user.apellidos)")
                    
                case .failure(let error):
                    self.responseMessage = "Error: \(error.localizedDescription)"
                    print("Error al intentar iniciar sesión: \(error.localizedDescription)")
                }
            }
        }
    }
}
