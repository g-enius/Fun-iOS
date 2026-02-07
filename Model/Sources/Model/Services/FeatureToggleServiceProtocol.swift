//
//  FeatureToggleServiceProtocol.swift
//  Model
//
//  Protocol for feature toggle service
//

import Foundation
import Combine

/// Identifies which feature toggle changed
public enum FeatureToggleKey {
    case featuredCarousel
    case simulateErrors
    case darkMode
}

@MainActor
public protocol FeatureToggleServiceProtocol: AnyObject {
    var featuredCarousel: Bool { get set }
    var simulateErrors: Bool { get set }
    var darkModeEnabled: Bool { get set }

    /// Publisher that emits the key of the toggle that changed
    var featureTogglesDidChange: AnyPublisher<FeatureToggleKey, Never> { get }
}
