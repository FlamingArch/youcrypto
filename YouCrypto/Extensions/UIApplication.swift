//
//  UIApplication.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 16/11/23.
//

import SwiftUI

extension UIApplication {
    // Dismiss the keyboard, uses primitive ObjC method.
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
