//
//  CoreTests.swift
//  CoreTests
//
//  Unit tests for Core module
//

import Testing
@testable import FunCore

// MARK: - ServiceLocator Tests

@Suite("ServiceLocator Tests")
struct ServiceLocatorTests {

    @Test("ServiceLocator shared instance exists")
    @MainActor
    func serviceLocatorExists() {
        #expect(ServiceLocator.shared != nil)
    }

    @Test("Can register and resolve a service")
    @MainActor
    func registerAndResolve() {
        let locator = ServiceLocator.shared
        locator.reset()

        let testService = TestService(value: 42)
        locator.register(testService, for: .logger)

        let resolved: TestService = locator.resolve(for: .logger)
        #expect(resolved.value == 42)

        locator.reset()
    }

    @Test("resolveOptional returns nil for unregistered service")
    @MainActor
    func resolveOptionalReturnsNil() {
        let locator = ServiceLocator.shared
        locator.reset()

        let resolved: TestService? = locator.resolveOptional(for: .network)
        #expect(resolved == nil)

        locator.reset()
    }

    @Test("isRegistered returns correct value")
    @MainActor
    func isRegisteredWorks() {
        let locator = ServiceLocator.shared
        locator.reset()

        #expect(locator.isRegistered(for: .logger) == false)

        locator.register(TestService(value: 1), for: .logger)
        #expect(locator.isRegistered(for: .logger) == true)

        locator.reset()
    }

    @Test("Fallback is used when primary service not registered")
    @MainActor
    func fallbackIsUsed() {
        let locator = ServiceLocator.shared
        locator.reset()
        locator.assertOnMissingService = false  // Disable assertion for testing

        let fallbackService = TestService(value: 999)
        locator.registerFallback(fallbackService, for: .analytics)

        // No primary registered, should use fallback
        let resolved: TestService = locator.resolve(for: .analytics)
        #expect(resolved.value == 999)

        locator.assertOnMissingService = true
        locator.reset()
    }

    @Test("Primary service takes precedence over fallback")
    @MainActor
    func primaryTakesPrecedence() {
        let locator = ServiceLocator.shared
        locator.reset()

        let primaryService = TestService(value: 100)
        let fallbackService = TestService(value: 999)

        locator.register(primaryService, for: .persistence)
        locator.registerFallback(fallbackService, for: .persistence)

        let resolved: TestService = locator.resolve(for: .persistence)
        #expect(resolved.value == 100)

        locator.reset()
    }

    @Test("verifyRequiredServices returns missing keys")
    @MainActor
    func verifyRequiredServicesWorks() {
        let locator = ServiceLocator.shared
        locator.reset()

        // Nothing registered - all required should be missing
        let missingAll = locator.verifyRequiredServices()
        #expect(missingAll.count == ServiceKey.requiredKeys.count)

        // Register some required services
        locator.register(TestService(value: 1), for: .network)
        locator.register(TestService(value: 2), for: .logger)

        let missingPartial = locator.verifyRequiredServices()
        #expect(!missingPartial.contains(.network))
        #expect(!missingPartial.contains(.logger))
        #expect(missingPartial.contains(.favorites))

        locator.reset()
    }

    @Test("reset clears all services and fallbacks")
    @MainActor
    func resetClearsEverything() {
        let locator = ServiceLocator.shared

        locator.register(TestService(value: 1), for: .network)
        locator.registerFallback(TestService(value: 2), for: .logger)

        #expect(locator.isRegistered(for: .network) == true)

        locator.reset()

        #expect(locator.isRegistered(for: .network) == false)
        let fallbackResolved: TestService? = locator.resolveOptional(for: .logger)
        #expect(fallbackResolved == nil)
    }
}

// MARK: - Test Helpers

private struct TestService {
    let value: Int
}
