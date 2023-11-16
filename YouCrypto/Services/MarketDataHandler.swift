//
//  MarketData.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 16/11/23.
//

import Foundation
import Combine

class MarketDataHandler {
    private var url = "https://api.coingecko.com/api/v3/global"
    @Published var marketData: MarketData? = nil
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    private func getMarketData() {
        guard let url = URL(string: self.url) else { return }
        
        marketDataSubscription = NetworkingHandler.download(url: url)
            .decode(type: MarketData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingHandler.handleCompletion, receiveValue: { [weak self] (returnMarketData) in
                self?.marketData = returnMarketData
                self?.marketDataSubscription?.cancel()
            })
    }
}
