//
//  PortfolioView.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 16/11/23.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var selectedCoin: Coin? = nil
    @State private var quantity = ""
    @State private var showCheckmark = false
    
    private func getCurrentValue() -> Double {
        guard let quantity = Double(quantity) else { return 0 }
        guard let currentCoinPrice = selectedCoin?.currentPrice else { return 0 }
        return quantity * currentCoinPrice
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    HStack {
                        CloseButton()
                        Spacer()
                        if selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantity)  {
                            NavigationButton(icon: "checkmark", label: "Save")
                        }
                    }.padding(.horizontal)
                    
                    
                    Text("Add Holdings")
                        .font(.title)
                        .padding(.horizontal)
                    
                    SearchBar(searchText: $viewModel.searchText)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    coinBadgeList
                    
                    if selectedCoin != nil {
                        holdingsDetailsForm
                    }
                    
                }
            }
            .padding(.vertical)
            .toolbar(.hidden)
        }
    }
}

extension PortfolioView {
    private var coinBadgeList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.allCoins) { coin in
                    CoinBadgeView(coin: coin, selected: (selectedCoin?.symbol ?? "") == coin.symbol)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedCoin = coin
                            }
                        }
                }
            }.padding(.horizontal)
        }
    }
    
    private var holdingsDetailsForm: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")").bold()
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }.padding()
            HStack {
                Text("Amount in Portfolio").bold()
                Spacer()
                TextField("0.00", text: $quantity)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }.padding()
            HStack {
                Text("Current Value").bold()
                Spacer()
                Text("\(getCurrentValue().asCurrencyWith2Decimals())")
            }.padding()
        }
        .animation(.none, value: selectedCoin == nil)
    }
    
    private var appBar: some View {
        HStack {
            CloseButton()
            Spacer()
            
            
            HStack {
                Image(systemName: "checkmark").foregroundStyle(Color.theme.accent)
                Spacer()
            }
            
            
            if selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantity)  {
                NavigationButton(icon: "checkmark", label: "Save")
            }
        }.padding(.horizontal)
    }
    
    private func handleSave() {
        guard let coin = selectedCoin else { return }
        
        withAnimation {
            self.showCheckmark = true
            clearCoinSelection()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
    
    func clearCoinSelection() {
        self.selectedCoin = nil
        viewModel.searchText = ""
    }
}

#Preview {
    PortfolioView().environmentObject(DeveloperPreview.instance.homeViewModel)
}
