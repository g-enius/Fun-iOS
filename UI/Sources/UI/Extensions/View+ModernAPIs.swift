//
//  View+ModernAPIs.swift
//  UI
//
//  SwiftUI View extensions for iOS 17+ APIs with backwards compatibility
//

import SwiftUI

// MARK: - Symbol Effects (iOS 17+)

extension View {
    /// Adds a bounce symbol effect when the value changes (iOS 17+)
    /// Falls back to no-op on iOS 15-16
    @ViewBuilder
    func symbolBounceEffect<T: Equatable>(value: T) -> some View {
        if #available(iOS 17.0, *) {
            self.symbolEffect(.bounce, value: value)
        } else {
            self
        }
    }

    /// Adds a symbol replace content transition (iOS 17+)
    /// Falls back to no-op on iOS 15-16
    @ViewBuilder
    func symbolReplaceTransition() -> some View {
        if #available(iOS 17.0, *) {
            self.contentTransition(.symbolEffect(.replace))
        } else {
            self
        }
    }
}

// MARK: - Sensory Feedback (iOS 17+)

extension View {
    /// Adds selection haptic feedback when the trigger value changes (iOS 17+)
    /// Falls back to no-op on iOS 15-16
    @ViewBuilder
    func selectionFeedback<T: Equatable>(trigger: T) -> some View {
        if #available(iOS 17.0, *) {
            self.sensoryFeedback(.selection, trigger: trigger)
        } else {
            self
        }
    }
}
