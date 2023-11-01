//
//  CoinImage.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 01/11/23.
//

import SwiftUI

struct CoinImage: View {
    @StateObject var viewModel: CoinImageViewModel
    
    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    CoinImage(coin: DeveloperPreview.instance.coin)
        .previewDevice(.none)
        .previewLayout(.sizeThatFits)
}
