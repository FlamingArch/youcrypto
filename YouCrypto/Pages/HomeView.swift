//
//  HomeView.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 01/11/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack  {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 16) {
                        NavigationButton(icon: "info", label: "Info")
                        Spacer()
                        NavigationButton(icon: "chevron.right", label: nil)
                    }
                    Text("Header")
                        .font(.system(size: 36))
                        .fontWeight(.regular)
                        .foregroundStyle(Color.theme.accent)
                }
                .padding()
                
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    HomeView()
}
