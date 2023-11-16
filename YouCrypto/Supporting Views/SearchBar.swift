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
            TextField("Search", text: $searchText)
                .disableAutocorrection(true)
        }
        .padding()
        .background(
            Capsule()
                .foregroundColor(.theme.secondaryText.opacity(0.16))
        )
        .overlay(alignment: .trailing) {
            Image(systemName: "xmark.circle.fill")
                .padding()
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
