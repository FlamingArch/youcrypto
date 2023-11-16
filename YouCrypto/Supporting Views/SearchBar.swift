//
//  SearchBar.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 16/11/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .frame(width: 50, height: 50)
            TextField("Search", text: $searchText)
                .disableAutocorrection(true)
        }
        .background(
            Capsule()
                .foregroundColor(.theme.secondaryText.opacity(0.16))
        )
        .overlay(alignment: .trailing) {
            Image(systemName: "xmark.circle.fill")
                .padding()
                .opacity(searchText.isEmpty ? 0 : 1)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    searchText = ""
                }
        }
    }
}

#Preview {
    SearchBar(searchText: .constant(""))
}
