//
//  StatisticView.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 16/11/23.
//

import SwiftUI

struct StatisticView: View {
    let stat: Statistic
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stat.title)
                    .font(.caption2)
                
                Text(stat.value)
                    .font(.footnote)
                    .bold()
                
                HStack {
                    Image(systemName: "triangle.fill")
                        .font(.caption2)
                        .rotationEffect(Angle(degrees: (stat.changePercentage ?? 0) >= 0 ? 0 : 180))
                    
                    Text(stat.changePercentage?.asPercentString() ?? "")
                        .font(.caption)
                        .bold()
                }
                .foregroundStyle((stat.changePercentage ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
                .opacity(stat.changePercentage == nil ? 0 : 1)
            }
            .padding(.vertical)
            .padding(.leading)
            .padding(.trailing, 2)
            
            Spacer()
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        StatisticView(stat: DeveloperPreview.instance.stat1)
        StatisticView(stat: DeveloperPreview.instance.stat2)
        StatisticView(stat: DeveloperPreview.instance.stat3)
    }
}
