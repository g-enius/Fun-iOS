//
//  DefaultFeatureToggleService.swift
//  Services
//
//  Default implementation of FeatureToggleServiceProtocol
//

import Foundation
import Combine
import FunModel

@MainActor
public final class DefaultFeatureToggleService: FeatureToggleServiceProtocol {

    // MARK: - Combine Publisher

    private let togglesChangedSubject = PassthroughSubject<Void, Never>()

    public var featureTogglesDidChange: AnyPublisher<Void, Never> {
        togglesChangedSubject.eraseToAnyPublisher()
    }

    // MARK: - Feature Toggles

    public var featuredCarousel: Bool {
        get { UserDefaults.standard.bool(forKey: .featureCarousel) }
        set {
            UserDefaults.standard.set(newValue, forKey: .featureCarousel)
            togglesChangedSubject.send()
        }
    }

    public var featureAnalytics: Bool {
        get { UserDefaults.standard.bool(forKey: .featureAnalytics) }
        set {
            UserDefaults.standard.set(newValue, forKey: .featureAnalytics)
            togglesChangedSubject.send()
        }
    }

    public var featureDebugMode: Bool {
        get { UserDefaults.standard.bool(forKey: .featureDebugMode) }
        set {
            UserDefaults.standard.set(newValue, forKey: .featureDebugMode)
            togglesChangedSubject.send()
        }
    }

    // MARK: - Initialization

    public init() {
        if UserDefaults.standard.object(forKey: .featureCarousel) == nil {
            UserDefaults.standard.set(true, forKey: .featureCarousel)
        }
    }
}
