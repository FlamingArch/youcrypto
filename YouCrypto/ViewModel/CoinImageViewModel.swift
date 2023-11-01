//
//  CoinImageViewModel.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 02/11/23.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = true
    
    private let coin: Coin
    private let dataService: CoinImageData
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.dataService = CoinImageData(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellables)
    }
}
