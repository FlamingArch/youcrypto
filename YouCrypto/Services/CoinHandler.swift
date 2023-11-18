//
//  CoinData.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 01/11/23.
//

import Foundation
import Combine

class CoinHandler {
    private var url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en"
    
    @Published var allCoins: [Coin] = []
    
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: self.url) else { return }
        
        coinSubscription = NetworkingHandler.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingHandler.handleCompletion, receiveValue: { [weak self] (returnCoins) in
                self?.allCoins = returnCoins
                self?.coinSubscription?.cancel()
            })
    }
}
