//
//  CoinBadgeView.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 17/11/23.
//

import SwiftUI

struct CoinBadgeView: View {
    let coin: Coin
    let selected: Bool
    
    var body: some View {
        VStack {
            CoinImage(coin: coin)
                .frame(width: 50, height: 50)
            
            Text(coin.symbol.uppercased())
                .font(.body)
                .lineLimit(1)
            
            Text(coin.name)
                .font(.caption)
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(width: 108, height: 128)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(
                    selected
                    ? Color.theme.secondaryText.opacity(0.64)
                    : Color.theme.secondaryText.opacity(0.16)
                )
        )
    }
}

#Preview {
    CoinBadgeView(coin: DeveloperPreview.instance.coin, selected: false)
}
