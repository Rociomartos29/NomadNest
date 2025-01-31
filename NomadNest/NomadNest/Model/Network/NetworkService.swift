//
//  NetworkService.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//
import Foundation
class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func login(username: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = URL(string: "http://localhost:4000/login")!  // URL del backend
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Cuerpo de la solicitud con las credenciales
        let parameters: [String: Any] = [
            "email": username,
            "password": password
        ]
        
        do {
            // Convierte el cuerpo en formato JSON
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // En caso de error al crear el cuerpo, lo reportamos
            completion(.failure(error))
            return
        }
        
        // Realizamos la solicitud HTTP
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Si ocurre un error en la solicitud, lo retornamos
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                // Si no se reciben datos, retornamos un error
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            do {
                // Intentamos decodificar la respuesta JSON
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        // Si el login es exitoso, devolvemos la respuesta
                        completion(.success(jsonResponse))
                    }
                } else {
                    // Si la respuesta no es un JSON válido, retornamos un error
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.decodingError))
                    }
                }
            } catch {
                // Si hubo un error al decodificar la respuesta
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume() // Iniciamos la tarea
    }
      func register(username: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let urlString = "http://localhost:4000/register"
        
        guard let url = URL(string: urlString) else {
            print("Error: URL inválida")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "username": username,
            "password": password,
            "firstName": firstName,
            "lastName": lastName
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        print("Enviando solicitud de registro a: \(urlString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al realizar la solicitud de registro: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No se recibió datos de la respuesta")
                completion(.failure(NetworkError.noData))
                return
            }
            
            print("Datos recibidos: \(String(describing: String(data: data, encoding: .utf8)))")
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Respuesta decodificada: \(jsonResponse)")
                    completion(.success(jsonResponse))
                } else {
                    print("Error al decodificar la respuesta")
                    completion(.failure(NetworkError.decodingError))
                }
            } catch {
                print("Error al procesar los datos JSON: \(error.localizedDescription)")
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}
