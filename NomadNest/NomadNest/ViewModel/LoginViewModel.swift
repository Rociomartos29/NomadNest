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
    
    func login() {
        // Realizar la llamada de login a tu API o backend
        NetworkService.shared.login(username: email, password: password) { result in
            switch result {
            case .success(let response):
                if let message = response["message"] as? String {
                    self.responseMessage = message
                }
            case .failure(let error):
                self.responseMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}
