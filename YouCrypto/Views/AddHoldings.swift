//
//  PortfolioView.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 16/11/23.
//

import SwiftUI

struct AddHoldingsView: View {
    @Environment(\.dismiss) var dismiss
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
                    appBar
                    
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

extension AddHoldingsView {
    private var coinBadgeList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.allCoinsOptionallyFiltered) { coin in
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
            
            Button {
                handleSave()
            } label: {
                HStack(spacing: 0) {
                    Spacer()
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .frame(width: 50, height: 50)
                    
                    Text("Save")
                    Spacer()
                }
                .padding(.trailing, 20)
                .foregroundColor(.primary)
                .background(
                    RoundedRectangle(cornerRadius: 999)
                        .foregroundColor(.theme.secondaryText.opacity(0.16))
                )
            }
            .padding()
            .opacity((selectedCoin == nil || quantity == "") ? 0.4 : 1.0)
            .disabled(selectedCoin == nil || quantity == "")
        }
        .animation(.none, value: selectedCoin == nil)
    }
    
    private var appBar: some View {
        HStack {
            CloseButton()
            Spacer()
        }.padding(.horizontal)
    }
    
    private func handleSave() {
        print("Saving Coin")
        
        guard
            let coin = selectedCoin,
            let amount = Double(quantity)
        else { return }
        
        viewModel.updatePortfolio(coin: coin, amount: amount)
        
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
        
        dismiss()
    }
    
    
    func clearCoinSelection() {
        self.selectedCoin = nil
        viewModel.searchText = ""
    }
}

#Preview {
    AddHoldingsView().environmentObject(DeveloperPreview.instance.homeViewModel)
}
