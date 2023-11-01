//
//  HomeView.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 01/11/23.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio = false
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack  {
                homeHeader
                
                List {
                    CoinRow(coin: DeveloperPreview.instance.coin, showHoldingsColumn: false)
                    CoinRow(coin: DeveloperPreview.instance.coin, showHoldingsColumn: true)
                    CoinRow(coin: DeveloperPreview.instance.coin, showHoldingsColumn: false)
                }
                .listStyle(.plain)
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}

// MARK: AppBar
extension HomeView {
    private var homeHeader: some View {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    NavigationButton(icon: showPortfolio ? "info" : "info", label: "Info")
                        .animation(.none, value: false)
                    Spacer()
                    NavigationButton(icon: "chevron.right", label: nil)
                        .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                        .onTapGesture {
                            withAnimation(.spring) {
                                showPortfolio.toggle()
                            }
                        }
                }
                Text("Live")
                    .font(.system(size: 36))
                    .fontWeight(.regular)
            }
            .padding()
    }
}
