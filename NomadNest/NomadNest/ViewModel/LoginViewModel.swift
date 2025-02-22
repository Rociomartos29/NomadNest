//
//  LoginViewModel.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import Foundation
import KeychainSwift

class LoginViewModel: ObservableObject {
    @Published var email = ""
        @Published var password = ""
        @Published var responseMessage = ""
        @Published var isLoggedIn = false
        @Published var user: User?
        
        private let networkService = NetworkService.shared
        
        // Verificar si hay un token guardado al iniciar la app
        func checkSession() {
            // Verifica si hay un token en Keychain
            if let savedToken = KeychainSwift().get("authToken"), !savedToken.isEmpty {
                // Si existe el token, el usuario está logueado
                self.isLoggedIn = true
                self.responseMessage = "Sesión iniciada automáticamente"
            } else {
                self.isLoggedIn = false
            }
        }
        
        // Función de login
        func login() {
            networkService.login(username: email, password: password) { result in
                switch result {
                case .success(let user):
                    self.user = user
                    self.isLoggedIn = true
                    self.responseMessage = "Login exitoso"
                case .failure(let error):
                    self.responseMessage = "Error: \(error.localizedDescription)"
                    self.isLoggedIn = false
                }
            }
        }
        
        // Función de logout
        func logout() {
            networkService.logout()
            self.isLoggedIn = false
            self.user = nil
            self.responseMessage = "Sesión cerrada"
        }
    }
