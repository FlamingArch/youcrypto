//
//  HomeViewModel.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 01/11/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins = [Coin]()
    @Published var portfolioCoins = [Coin]()
    
    @Published var searchText: String = ""
    
    private let dataService = CoinData()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSampleCoinAsynchronously(delay: Double = 2.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.allCoins.append(DeveloperPreview.instance.coin)
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
    }
    
    func addSubscribers() {
        // dataService.$allCoins
        //     .sink { [weak self] returnedCoins in
        //         self?.allCoins = returnedCoins
        //     }
        //     .store(in: &cancellables)
        
        // Updates all coins
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // Wait 0.5 seconds for additional input before filtering
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
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

