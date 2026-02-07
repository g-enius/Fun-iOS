//
//  MockFeatureToggleService.swift
//  Model
//
//  Mock implementation of FeatureToggleServiceProtocol for testing
//

import Foundation
import Combine

@MainActor
public final class MockFeatureToggleService: FeatureToggleServiceProtocol {

    private let togglesChangedSubject = PassthroughSubject<FeatureToggleKey, Never>()

    public var featureTogglesDidChange: AnyPublisher<FeatureToggleKey, Never> {
        togglesChangedSubject.eraseToAnyPublisher()
    }

    public var featuredCarousel: Bool {
        didSet { togglesChangedSubject.send(.featuredCarousel) }
    }

    public var simulateErrors: Bool {
        didSet { togglesChangedSubject.send(.simulateErrors) }
    }

    public var darkModeEnabled: Bool {
        didSet { togglesChangedSubject.send(.darkMode) }
    }

    public init(featuredCarousel: Bool = true, simulateErrors: Bool = false, darkModeEnabled: Bool = false) {
        self.featuredCarousel = featuredCarousel
        self.simulateErrors = simulateErrors
        self.darkModeEnabled = darkModeEnabled
    }
}
