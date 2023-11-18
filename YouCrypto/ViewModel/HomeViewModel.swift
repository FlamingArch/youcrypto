//
//  HomeViewModel.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 01/11/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var statistics: [Statistic] = [
        Statistic(title: "Title", value: "Value", changePercentage: 1),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value", changePercentage: -4),
        Statistic(title: "Title", value: "Value")
    ]
    
    
    @Published var allCoinsOptionallyFiltered = [Coin]()
    @Published var marketData: MarketData? = nil
    
    @Published var portfolioCoins = [Coin]()
    
    @Published var isLoading = false
    @Published var searchText: String = ""
    
    private let coinHandler = CoinHandler()
    private let marketDataHandler = MarketDataHandler()
    private let portfolioDataHandler = PortfolioDataHandler()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSampleCoinAsynchronously(delay: Double = 2.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.allCoinsOptionallyFiltered.append(DeveloperPreview.instance.coin)
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest(coinHandler.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // Wait 0.5 seconds for additional input before filtering
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoinsOptionallyFiltered = returnedCoins
            }
            .store(in: &cancellables)
        
        $allCoinsOptionallyFiltered
            .combineLatest(portfolioDataHandler.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketDataHandler.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedMarketData in
                self?.statistics = returnedMarketData
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataHandler.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinHandler.getCoins()
        marketDataHandler.getMarketData()
        HapticsHandler.notification(type: .success)
    }
}

// MARK: Mapping Functions
extension HomeViewModel {
    private func mapAllCoinsToPortfolioCoins(allCoins coins: [Coin], portfolioCoins portfolioEntities: [Portfolio]) -> [Coin] {
        coins
            .compactMap { coin -> Coin? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else { return nil }
                return coin.updateHoldings(amount: entity.currentHoldings)
            }
    }
    
    private func mapGlobalMarketData(data receivedMarketData: MarketData?, portfolioData receivedPortfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let receivedMarketData = receivedMarketData else {
            return stats
        }
        
        let portfolioValue = portfolioCoins.reduce(0) { $0 + $1.currentHoldingsValue }
        
        let previousPortfolioValue = portfolioCoins.reduce(0, { prevValue, coin in
            let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = coin.currentHoldingsValue * (1 + percentageChange)
            return previousValue + prevValue
        })
        
        let changePercentage = ((portfolioValue - previousPortfolioValue) / previousPortfolioValue) * 100
        
        stats.append(contentsOf: [
            Statistic(title: "Market Cap", value: receivedMarketData.marketCap, changePercentage: receivedMarketData.marketCapChangePercentage24HUsd),
            Statistic(title: "24H Volume", value: receivedMarketData.volume),
            Statistic(title: "BTC Dominance", value: receivedMarketData.btcDominance),
            Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), changePercentage: changePercentage),
        ])
        return stats
    }
}

// MARK: Utilities
extension HomeViewModel {
    private func filterCoins(text: String, coins startingCoins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return startingCoins
        }
        
        let lowercasedText = text.lowercased()
        
        return startingCoins.filter {
            return $0.name.lowercased().contains(lowercasedText)
            || $0.symbol.lowercased().contains(lowercasedText)
            || $0.id.lowercased().contains(lowercasedText)
        }
    }
}
