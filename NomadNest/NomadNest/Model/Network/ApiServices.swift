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
        guard let url = URL(string: "\(baseURL)/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.responseMessage = "Error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else { return }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        self.responseMessage = json["message"] as? String ?? "Sin respuesta del servidor"
                    }
                } catch {
                    self.responseMessage = "Error al procesar la respuesta"
                }
            }
        }

        task.resume()
    }

    func register(username: String, password: String) {
        guard let url = URL(string: "\(baseURL)/register") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.responseMessage = "Error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else { return }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        self.responseMessage = json["message"] as? String ?? "Sin respuesta del servidor"
                    }
                } catch {
                    self.responseMessage = "Error al procesar la respuesta"
                }
            }
        }

        task.resume()
    }
}
