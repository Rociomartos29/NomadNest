//
//  KeychainHelper.swift
//  NomadNest
//
//  Created by Rocio Martos on 22/2/25.
//

import Foundation
import Security

class KeychainHelper {
    
    // Método para guardar datos en Keychain
    func set(_ value: String, forKey key: String) -> Bool {
        if let data = value.data(using: .utf8) {
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecValueData: data
            ]
            
            // Intentamos agregar el nuevo dato o actualizar si ya existe
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            
            return status == errSecSuccess
        }
        return false
    }
    
    // Método para obtener un valor de Keychain
    func get(forKey key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data, let value = String(data: data, encoding: .utf8) {
            return value
        }
        return nil
    }
    
    // Método para eliminar un valor de Keychain
    func delete(forKey key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
