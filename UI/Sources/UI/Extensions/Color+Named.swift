//
//  Color+Named.swift
//  UI
//
//  Extension for mapping string color names to SwiftUI Colors
//

import SwiftUI

extension Color {
    /// Creates a Color from a string name used in FeaturedItem data
    /// - Parameter name: Color name string (e.g., "green", "blue", "purple")
    /// - Returns: Corresponding SwiftUI Color, defaults to .gray for unknown names
    static func named(_ name: String) -> Color {
        switch name {
        case "green": return .green
        case "orange": return .orange
        case "blue": return .blue
        case "purple": return .purple
        case "indigo": return .indigo
        case "brown": return .brown
        case "teal": return .teal
        case "mint": return .mint
        case "cyan": return .cyan
        case "gray": return .gray
        case "red": return .red
        case "pink": return .pink
        case "yellow": return .yellow
        default: return .gray
        }
    }
}
