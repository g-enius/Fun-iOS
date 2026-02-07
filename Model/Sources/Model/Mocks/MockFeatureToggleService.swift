//
//  MockFeatureToggleService.swift
//  Model
//
//  Mock implementation of FeatureToggleServiceProtocol for testing
//

import Combine
import Foundation

@MainActor
public final class MockFeatureToggleService: FeatureToggleServiceProtocol {

    @Published public var featuredCarousel: Bool
    @Published public var simulateErrors: Bool
    @Published public var darkModeEnabled: Bool

    public var featuredCarouselPublisher: AnyPublisher<Bool, Never> {
        $featuredCarousel.dropFirst().removeDuplicates().eraseToAnyPublisher()
    }

    public var simulateErrorsPublisher: AnyPublisher<Bool, Never> {
        $simulateErrors.dropFirst().removeDuplicates().eraseToAnyPublisher()
    }

    public var darkModePublisher: AnyPublisher<Bool, Never> {
        $darkModeEnabled.dropFirst().removeDuplicates().eraseToAnyPublisher()
    }

    public init(featuredCarousel: Bool = true, simulateErrors: Bool = false, darkModeEnabled: Bool = false) {
        self.featuredCarousel = featuredCarousel
        self.simulateErrors = simulateErrors
        self.darkModeEnabled = darkModeEnabled
    }
}
