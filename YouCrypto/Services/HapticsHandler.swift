//
//  HapticsHandler.swift
//  YouCrypto
//
//  Created by Harsh Chaturvedi on 18/11/23.
//

import SwiftUI

class HapticsHandler {
    private static let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
