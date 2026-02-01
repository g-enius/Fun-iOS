//
//  FeatureToggleServiceProtocol.swift
//  Model
//
//  Protocol for feature toggle service
//

import Foundation

@MainActor
public protocol FeatureToggleServiceProtocol: AnyObject {
    var featuredCarousel: Bool { get set }
    var featureAnalytics: Bool { get set }
    var featureDebugMode: Bool { get set }
}

// MARK: - Notification Names

public extension Notification.Name {
    static let featureTogglesDidChange = Notification.Name("featureTogglesDidChange")
    static let appSettingsDidChange = Notification.Name("AppSettingsChanged")
}
