//
//  RoundedButton.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 01/11/23.
//

import SwiftUI

struct NavigationButton: View {
    let icon: String?
    let label: String?
    
    var body: some View {
        HStack(spacing: 0) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.headline)
                    .frame(width: 50, height: 50)
            }
            
            if let label = label {
                Text(label)
            }
        }
        .padding(.trailing, label != nil ? 20 : 0)
        .foregroundColor(.primary)
        .background(
            RoundedRectangle(cornerRadius: 999)
                .foregroundColor(.theme.secondaryText.opacity(0.16))
        )
    }
}
