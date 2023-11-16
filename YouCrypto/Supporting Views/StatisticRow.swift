//
//  StatisticRow.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 16/11/23.
//

import SwiftUI

struct StatisticRow: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        GeometryReader { bounds in
            HStack(spacing: 0) {
                ForEach(viewModel.statistics) {
                    StatisticView(stat: $0)
                        .frame(width: bounds.size.width / 3 - 21)
                        .background(RoundedRectangle(cornerRadius: 16).foregroundStyle(Color.theme.secondaryText.opacity(0.16)))
                        .padding(.trailing, 16)
                }
            }
            .padding(.leading, 16)
            .frame(width: bounds.size.width, alignment: showPortfolio ? .trailing : .leading)
        }.frame(height: 72)
    }
}

#Preview {
    StatisticRow(showPortfolio: .constant(false))
        .environmentObject(DeveloperPreview.instance.homeViewModel)
}
