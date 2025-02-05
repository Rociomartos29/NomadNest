//
//  extensions.swift
//  NomadNest
//
//  Created by Rocio Martos on 5/2/25.
//
import SwiftUI
// Extensión para usar colores hexadecimales
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1 // Saltamos el símbolo '#'
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
