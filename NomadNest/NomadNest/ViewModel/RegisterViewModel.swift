//
//  RegisterViewModel.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var responseMessage = ""
    
    func register() {
        // Realizar la llamada de registro a tu API o backend
        NetworkService.shared.register(username: email, password: password, firstName: firstName, lastName: lastName) { result in
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
