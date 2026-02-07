//
//  DefaultFeatureToggleServiceTests.swift
//  Services
//
//  Unit tests for DefaultFeatureToggleService
//

import Testing
import Foundation
import Combine
@testable import FunServices
@testable import FunModel

@Suite("DefaultFeatureToggleService Tests")
@MainActor
struct DefaultFeatureToggleServiceTests {

    // Helper to clear UserDefaults before each test
    private func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "feature.carousel")
    }

    // MARK: - Initialization Tests

    @Test("Featured carousel defaults to true on first launch")
    func testFeaturedCarouselDefaultsToTrue() async {
        clearUserDefaults()
        let service = DefaultFeatureToggleService()

        #expect(service.featuredCarousel == true)
    }

    // MARK: - Persistence Tests

    @Test("Featured carousel persists to UserDefaults")
    func testFeaturedCarouselPersistence() async {
        clearUserDefaults()
        let service = DefaultFeatureToggleService()

        service.featuredCarousel = false
        #expect(UserDefaults.standard.bool(forKey: "feature.carousel") == false)

        service.featuredCarousel = true
        #expect(UserDefaults.standard.bool(forKey: "feature.carousel") == true)
    }

    // MARK: - Combine Publisher Tests

    @Test("Setting featured carousel emits via publisher")
    func testFeaturedCarouselEmitsViaPublisher() async {
        clearUserDefaults()
        let service = DefaultFeatureToggleService()
        var receivedValue: Bool?
        var cancellables = Set<AnyCancellable>()

        service.featuredCarouselPublisher
            .sink { receivedValue = $0 }
            .store(in: &cancellables)

        service.featuredCarousel = false

        // Wait a moment for publisher
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(receivedValue == false)
    }

    // MARK: - State Restoration Tests

    @Test("Service restores state from UserDefaults")
    func testStateRestoration() async {
        clearUserDefaults()

        // Set values directly in UserDefaults
        UserDefaults.standard.set(false, forKey: "feature.carousel")

        // Create new service instance
        let service = DefaultFeatureToggleService()

        #expect(service.featuredCarousel == false)
    }
}
