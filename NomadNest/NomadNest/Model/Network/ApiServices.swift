//
//  ApiServices.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//

import Foundation

class APIService: ObservableObject {
    private let baseURL = "http://localhost:4000" // URL del servidor Node.js
    
    @Published var responseMessage: String? // Variable para mostrar mensajes en la UI

    func login(username: String, password: String) {
        guard let url = URL(string: "\(baseURL)/login") else {
            print("Error: URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        print("Enviando solicitud de login a: \(url)")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error al realizar la solicitud de login: \(error.localizedDescription)")
                    self.responseMessage = "Error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    print("No se recibió datos de la respuesta")
                    self.responseMessage = "No se recibió datos"
                    return
                }

                print("Datos recibidos: \(String(describing: String(data: data, encoding: .utf8)))")
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("Respuesta decodificada: \(json)")
                        self.responseMessage = json["message"] as? String ?? "Sin respuesta del servidor"
                    }
                } catch {
                    print("Error al procesar la respuesta: \(error.localizedDescription)")
                    self.responseMessage = "Error al procesar la respuesta"
                }
            }
        }

        task.resume()
    }

    func register(username: String, password: String) {
        guard let url = URL(string: "\(baseURL)/register") else {
            print("Error: URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        print("Enviando solicitud de registro a: \(url)")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error al realizar la solicitud de registro: \(error.localizedDescription)")
                    self.responseMessage = "Error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    print("No se recibió datos de la respuesta")
                    self.responseMessage = "No se recibió datos"
                    return
                }

                print("Datos recibidos: \(String(describing: String(data: data, encoding: .utf8)))")
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("Respuesta decodificada: \(json)")
                        self.responseMessage = json["message"] as? String ?? "Sin respuesta del servidor"
                    }
                } catch {
                    print("Error al procesar la respuesta: \(error.localizedDescription)")
                    self.responseMessage = "Error al procesar la respuesta"
                }
            }
        }

        task.resume()
    }
}
