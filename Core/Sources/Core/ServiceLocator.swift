//
//  ServiceLocator.swift
//  Core
//
//  Central registry for dependency injection
//

import Foundation

// MARK: - Service Key

/// Enum defining all available services
public enum ServiceKey: CaseIterable {
    case network
    case persistence
    case analytics
    case logger
    case auth
    case favorites
    case toast
    case featureToggles

    /// Keys that must be registered at app startup
    public static var requiredKeys: [ServiceKey] {
        [.network, .logger, .favorites, .featureToggles, .toast]
    }
}

// MARK: - Service Locator

/// Central registry for all services
@MainActor
public class ServiceLocator {

    /// Shared instance
    public static let shared = ServiceLocator()

    /// Registered services
    private var services: [String: Any] = [:]

    /// Fallback services (used when primary service not registered)
    private var fallbacks: [String: Any] = [:]

    private init() {
        // Private to enforce singleton
    }

    /// Register a service
    public func register<T>(_ service: T, for key: ServiceKey) {
        let keyString = String(describing: key)
        services[keyString] = service
    }

    /// Register a fallback service (used if primary not registered)
    /// Fallbacks are used in production to prevent crashes
    public func registerFallback<T>(_ fallback: T, for key: ServiceKey) {
        let keyString = String(describing: key)
        fallbacks[keyString] = fallback
    }

    /// Flag to enable assertion failures (disabled during testing)
    public var assertOnMissingService: Bool = true

    /// Resolve a service
    /// - If service is registered, returns it
    /// - If not but fallback exists, logs warning (assertionFailure in debug) and returns fallback
    /// - If neither exists, crashes with fatalError
    public func resolve<T>(for key: ServiceKey) -> T {
        let keyString = String(describing: key)

        // Primary service registered - return it
        if let service = services[keyString] as? T {
            return service
        }

        // Fallback exists - use it with debug warning
        if let fallback = fallbacks[keyString] as? T {
            let message = "Service not registered for key: \(key). Using fallback. " +
                "Register in ServiceLocator.shared before app startup."
            #if DEBUG
            // assertionFailure crashes in debug builds to catch issues early
            // Use assertOnMissingService = false in tests to disable
            if assertOnMissingService {
                assertionFailure(message)
            }
            #endif
            return fallback
        }

        // No service or fallback - crash
        fatalError(
            "Service not registered for key: \(key). Register in ServiceLocator.shared."
        )
    }

    /// Resolve an optional service (doesn't crash if not found)
    public func resolveOptional<T>(for key: ServiceKey) -> T? {
        let keyString = String(describing: key)
        return services[keyString] as? T
    }

    /// Check if a service is registered
    public func isRegistered(for key: ServiceKey) -> Bool {
        let keyString = String(describing: key)
        return services[keyString] != nil
    }

    /// Verify all required services are registered
    /// Returns list of missing service keys
    public func verifyRequiredServices() -> [ServiceKey] {
        ServiceKey.requiredKeys.filter { !isRegistered(for: $0) }
    }

    /// Unregister a service (useful for testing)
    public func unregister(for key: ServiceKey) {
        let keyString = String(describing: key)
        services.removeValue(forKey: keyString)
    }

    /// Clear all services (useful for testing)
    public func reset() {
        services.removeAll()
        fallbacks.removeAll()
        assertOnMissingService = true
    }
}

// MARK: - @Service Property Wrapper

/// Property wrapper for convenient service access
///
/// Usage:
/// ```swift
/// class MyViewModel {
///     @Service(.network) var networkService
///     @Service(.logger) var logger
/// }
/// ```
@propertyWrapper
@MainActor
public struct Service<T> {

    private let key: ServiceKey

    public init(_ key: ServiceKey) {
        self.key = key
    }

    public var wrappedValue: T {
        ServiceLocator.shared.resolve(for: key)
    }
}
