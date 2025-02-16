//
//  SearchHeaderView.swift
//  NomadNest
//
//  Created by Rocio Martos on 5/2/25.
//

import SwiftUI

struct SearchHeaderView: View {
    @Binding var searchQuery: String  // Enlace para obtener el valor del texto
      @State private var isEditing = false
      
      var body: some View {
          VStack {
              TextField("Buscar ciudad...", text: $searchQuery)  // Campo de texto
                  .padding(10)
                  .background(Color.white.opacity(0.8))
                  .cornerRadius(8)
                  .padding(.horizontal)
                  .onTapGesture {
                      self.isEditing = true  // Marcar que está siendo editado
                  }
                  .overlay(
                      HStack {
                          Spacer()
                          if isEditing {
                              Button(action: {
                                  self.searchQuery = ""  // Botón para limpiar el campo
                              }) {
                                  Image(systemName: "xmark.circle.fill")
                                      .foregroundColor(.gray)
                              }
                              .padding(.trailing)
                          }
                      }
                  )
                  .font(.title3)
                  .foregroundColor(.black)
                  .keyboardType(.default)
              
          }
      }
  }
#Preview {
    SearchHeaderView(searchQuery: .constant(""))
}
