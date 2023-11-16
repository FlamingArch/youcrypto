//
//  Statistic.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 16/11/23.
//

import Foundation

struct Statistic: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let changePercentage: Double?
    
    init(title: String, value: String, changePercentage: Double? = nil) {
        self.title = title
        self.value = value
        self.changePercentage = changePercentage
    }
}

let newModel = Statistic(title: "", value: "")
