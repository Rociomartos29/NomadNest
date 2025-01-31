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
    
    func login() {
        // Llamada al servicio de red para hacer el login
        NetworkService.shared.login(username: email, password: password) { result in
            switch result {
            case .success(let response):
                if let message = response["message"] as? String {
                    DispatchQueue.main.async {
                        if message == "Login exitoso" {
                            self.isLoggedIn = true
                        } else {
                            self.responseMessage = message
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.responseMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
