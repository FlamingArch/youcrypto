//
//  CloseButton.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 16/11/23.
//

import SwiftUI

struct CloseButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationButton(icon: "xmark", label: nil)
            .padding(.bottom)
            .onTapGesture { dismiss() }
    }
}

#Preview {
    CloseButton()
}
