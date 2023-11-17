//
//  HomeView.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 01/11/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortfolio = false        // Page showing holdings, sliding in from trailing
    @State private var showSearchBar = false
    @State private var showPortfolioView = false    // New sheet to add holdings
    
    var body: some View {
        VStack  {
            homeHeader
            columnTitles
            if !showPortfolio {
                allCoinsList
            } else {
                portfolioCoinsList
            }
            Spacer()
        }
        .sheet(isPresented: $showPortfolioView) { AddHoldingsView().environmentObject(viewModel) }
    }
}

#Preview {
    HomeView()
        .environmentObject(DeveloperPreview.instance.homeViewModel)
}

// MARK: AppBar
extension HomeView {
    private var homeHeader: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 16) {
                if !showSearchBar{
                    NavigationButton(icon: showPortfolio ? "plus" : "info", label: showPortfolio ? "Add" : "Info")
                        .animation(.none, value: showPortfolio)
                        .transition(.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
                        .onTapGesture {
                            if showPortfolio {
                                showPortfolioView = true
                            }
                        }
                    
                    Spacer()
                }
                
                
                if showSearchBar {
                    NavigationButton(icon: "chevron.left", label: nil)
                        .onTapGesture {
                            withAnimation {
                                showSearchBar = false
                                viewModel.searchText = ""
                            }
                        }
                        .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
                    
                    SearchBar(searchText: $viewModel.searchText)
                        .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
                }
                
                
                if !showSearchBar && !showPortfolio {
                    NavigationButton(icon: showSearchBar ? "xmark.circle" : "magnifyingglass", label: nil)
                        .animation(.none, value: showSearchBar)
                        .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
                        .onTapGesture {
                            withAnimation(.spring) {
                                showSearchBar = true
                            }
                        }
                }
                
                if !showSearchBar {
                    NavigationButton(icon: "chevron.right", label: nil)
                        .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                        .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
                        .onTapGesture {
                            withAnimation(.spring) {
                                showPortfolio.toggle()
                            }
                        }
                }
            }
            .padding(.horizontal)
            
            StatisticRow(showPortfolio: $showPortfolio)
                .padding(.bottom)
            
            Text("Live")
                .font(.system(size: 36))
                .fontWeight(.regular)
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
        .padding(.bottom, 0)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoinsOptionallyFiltered) {
                CoinRow(coin: $0, showHoldingsColumn: false)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 16, leading: 8, bottom: 16, trailing: 16))
            }
        }
        .listStyle(.plain)
        .transition(.move(edge: .leading))
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) {
                CoinRow(coin: $0, showHoldingsColumn: true)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 20, leading: 20, bottom: 20, trailing: 20))
            }
        }
        .listStyle(.plain)
        .transition(.move(edge: .trailing))
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            
            Spacer()
            
            if showPortfolio{
                Text("Holdings")
            }
            
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
