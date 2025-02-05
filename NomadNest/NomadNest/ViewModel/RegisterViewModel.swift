//
//  RegisterViewModel.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var nombre = ""
    @Published var apellido = ""
    @Published var email = ""
    @Published var password = ""
    @Published var responseMessage: String = ""
    @Published var isRegistered: Bool = false
    @Published var isError: Bool = false
    
    
    func register() {
        print("Intentando registrar usuario con los siguientes datos:")
        print("Nombre: \(nombre), Apellido: \(apellido), Email: \(email), Contraseña: \(password)")
        
        NetworkService.shared.register(nombre: nombre, apellidos: apellido, email: email, password: password) { result in
            switch result {
            case .success(let response):
                print("Registro exitoso: \(response)")
                DispatchQueue.main.async {
                    // Al recibir éxito, cambiamos el estado de registro a verdadero
                    self.responseMessage = "Usuario registrado exitosamente"
                    self.isError = false
                    self.isRegistered = true // Cambiar a true para activar el NavigationLink
                }
            case .failure(let error):
                print("Error al registrar: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.responseMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
