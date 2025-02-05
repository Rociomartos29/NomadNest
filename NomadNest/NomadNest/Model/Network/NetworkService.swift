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
    
    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "http://localhost:4000/login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "email": username,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            print("Cuerpo de la solicitud (login): \(String(data: request.httpBody!, encoding: .utf8) ?? "")")
        } catch {
            completion(.failure(error))
            return
        }
        
        print("Enviando solicitud de login a: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            print("Datos recibidos de la respuesta en el login: \(String(describing: String(data: data, encoding: .utf8)))")
            
            do {
                // Intentar decodificar la respuesta como LoginResponse
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                print("Login exitoso: \(loginResponse.message)")
                DispatchQueue.main.async {
                    completion(.success(loginResponse.user))
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error al decodificar la respuesta del login: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }.resume()
    }
    
    func register(nombre: String, apellidos: String, email: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let urlString = "http://localhost:4000/register"
        
        guard let url = URL(string: urlString) else {
            print("URL inválida para registro: \(urlString)")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "nombre": nombre,
            "apellidos": apellidos,
            "email": email,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            print("Cuerpo de la solicitud (registro): \(String(data: request.httpBody!, encoding: .utf8) ?? "")")
        } catch {
            print("Error al serializar el cuerpo del request (registro): \(error)")
            completion(.failure(error))
            return
        }
        
        print("Enviando solicitud de registro a: \(urlString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al realizar la solicitud de registro: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No se recibieron datos de la respuesta en el registro")
                completion(.failure(NetworkError.noData))
                return
            }
            
            print("Datos recibidos de la respuesta en el registro: \(String(describing: String(data: data, encoding: .utf8)))")
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Respuesta recibida del registro: \(jsonResponse)")
                    completion(.success(jsonResponse))
                } else {
                    print("Error al decodificar la respuesta en el registro")
                    completion(.failure(NetworkError.decodingError))
                }
            } catch {
                print("Error al procesar los datos JSON en el registro: \(error.localizedDescription)")
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
    func fetchDestinations(completion: @escaping (Result<[Destination], Error>) -> Void) {
        let url = URL(string: "http://localhost:4000/destinations")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            print("Datos recibidos de la respuesta al obtener destinos: \(String(describing: String(data: data, encoding: .utf8)))")
            
            do {
                // Decodificar la respuesta como DestinationsResponse
                let destinationsResponse = try JSONDecoder().decode(DestinationsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(destinationsResponse.destinations))
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error al decodificar los datos de los destinos: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }.resume()
    }
}
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}
