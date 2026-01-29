import SwiftUI

struct AppColors {
    static let background = Color(red: 0.08, green: 0.08, blue: 0.12)
    static let cardBackground = Color(red: 0.12, green: 0.12, blue: 0.18)
    static let primaryGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let secondaryBrown = Color(red: 0.6, green: 0.4, blue: 0.2)
    static let accentGold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let accentBlue = Color(red: 0.3, green: 0.6, blue: 1.0)
    
    static let primaryGradient = LinearGradient(
        colors: [Color(red: 0.2, green: 0.8, blue: 0.4), Color(red: 0.1, green: 0.6, blue: 0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [Color(red: 0.6, green: 0.4, blue: 0.2), Color(red: 0.4, green: 0.3, blue: 0.15)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let successGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 0.9, green: 0.6, blue: 0.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cosmicGradient = LinearGradient(
        colors: [Color(red: 0.3, green: 0.6, blue: 1.0), Color(red: 0.5, green: 0.3, blue: 0.9)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [Color(red: 0.08, green: 0.08, blue: 0.12), Color(red: 0.05, green: 0.05, blue: 0.08)],
        startPoint: .top,
        endPoint: .bottom
    )
}
