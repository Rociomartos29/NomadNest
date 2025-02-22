//
//  NetworkService.swift
//  NomadNest
//
//  Created by Rocio Martos on 29/1/25.
//
import Foundation
import CoreLocation
import KeychainSwift

class NetworkService {
    static let shared = NetworkService()
    private let googlePlacesAPIKey = "AIzaSyCg3flfAqOsUTgpLhFbyQUW7cRPeXnEAlw"
    private let keychain = KeychainHelper()
    private init() {}
    
    // Función de login
    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "http://localhost:4000/login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Parámetros de la solicitud
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
            // Manejo de errores
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
            
            // Intentamos decodificar la respuesta (cuerpo de la respuesta)
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                print("Login exitoso: \(loginResponse.message)")
                
                // Guardamos el token en Keychain
                if let token = loginResponse.token {
                    self.keychain.set(token, forKey: "authToken")
                    print("Token recibido y guardado en Keychain: \(token)")
                }
                
                DispatchQueue.main.async {
                    // Enviamos la respuesta con el usuario al completion
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
        
        // Función para verificar si el token existe (para comprobar si ya está logueado)
        func checkSession() -> Bool {
            // Verificamos si hay un token guardado en Keychain
            if let token = keychain.get(forKey: "authToken"), !token.isEmpty {
                return true // Si hay token, se considera que la sesión está activa
            }
            return false // Si no hay token, la sesión no está activa
        }
        
        // Función para hacer logout (eliminar el token de Keychain)
        func logout() {
            // Eliminamos el token de Keychain al cerrar sesión
            keychain.delete(forKey: "authToken")
        }
    
   
      // Función para registrar un nuevo usuario
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

      // Función para obtener destinos
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
    func fetchNearbyPlaces(type: String, location: CLLocationCoordinate2D, radius: Int = 1500, completion: @escaping (Result<[Place], Error>) -> Void) {
        let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        
        // Parámetros de la solicitud
        let parameters: [String: Any] = [
            "location": "\(location.latitude),\(location.longitude)",
            "radius": radius,
            "type": type,
            "key": googlePlacesAPIKey
        ]
        
        // Construir la URL con los parámetros
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        
        guard let url = urlComponents?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Realizar la solicitud
        URLSession.shared.dataTask(with: url) { data, response, error in
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
            
            do {
                // Decodificar la respuesta
                let placesResponse = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
                
                // Aquí podemos mapear las imágenes y agregar fotos a cada Place
                let placesWithPhotos = placesResponse.results.map { (place) -> Place in// `place` es mutable ahora
                    var placeWithPhotos = place
                    placeWithPhotos.photos = placeWithPhotos.photos?.map { photo in
                        return photo
                    }
                    return placeWithPhotos
                }
                
                DispatchQueue.main.async {
                    completion(.success(placesWithPhotos))
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error al decodificar la respuesta de Google Places: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }.resume()
    }
    func fetchCoordinates(for city: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        let baseURL = "https://maps.googleapis.com/maps/api/geocode/json"
        let parameters: [String: Any] = [
            "address": city,
            "key": googlePlacesAPIKey
        ]
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        
        guard let url = urlComponents?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
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
            
            do {
                let response = try JSONDecoder().decode(GeocodeResponse.self, from: data)
                if let location = response.results.first?.geometry.location {
                    let coordinates = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
                    DispatchQueue.main.async {
                        completion(.success(coordinates))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.decodingError))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }.resume()
    }
    func fetchImageURL(for photoReference: String, completion: @escaping (Result<String, Error>) -> Void) {
        let baseURL = "https://maps.googleapis.com/maps/api/place/photo"
        
        // Supongamos que las imágenes no deben ser mayores a 400px de ancho
        let urlString = "\(baseURL)?photoreference=\(photoReference)&maxwidth=400&key=\(googlePlacesAPIKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Realizamos la solicitud para obtener la imagen
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let _ = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Si todo es exitoso, devolvemos la URL de la imagen
            completion(.success(urlString))
        }.resume()
    }
}
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case noToken
    case keychainError
}
