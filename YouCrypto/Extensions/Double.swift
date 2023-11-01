//
//  Double.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 01/11/23.
//

import Foundation

extension Double {
    
    /// Converts Double into Currenct with 2-6 digits after decimal
    /// ```
    /// Convert 1234.56 to ₹1,234.56
    /// Convert 12.3456 to ₹12.3456
    /// Convert 0.123456 to ₹0.123456
    /// Convert 0.1234567 to ₹0.123456
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current // Default value
        formatter.currencyCode = "inr" // Change Currency
        formatter.currencySymbol = "₹" // Change Currency Symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current // Default value
        formatter.currencyCode = "inr" // Change Currency
        formatter.currencySymbol = "₹" // Change Currency Symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// Converts Double into Currency as a string with 2 digits after decimal
    /// ```
    /// Convert 1234.56 to "₹1,234.56"
    /// Convert 12.3456 to "₹12.34"
    /// Convert 0.123456 to "₹0.12"
    /// Convert 0.1234567 to "₹0.12"
    /// ```
    func asCurrencyWith2Decimals() -> String {
        let number  = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "₹0.00"
    }
    
    /// Converts Double into Currency as a string with 2-6 digits after decimal
    /// ```
    /// Convert 1234.56 to "₹1,234.56"
    /// Convert 12.3456 to "₹12.3456"
    /// Convert 0.123456 to "₹0.123456"
    /// Convert 0.1234567 to "₹0.123456"
    /// ```
    func asCurrencyWith6Decimals() -> String {
        let number  = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "₹0.00"
    }
    
    /// Converts a double into a String representation with 2 digits after decimal
    /// ```
    /// Convert 1.2345 to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Converts a double into a String representation suffixed by a percent symbol '%' with 2 digits after decimal
    /// ```
    /// Convert 1.2345 to "1.23"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
}