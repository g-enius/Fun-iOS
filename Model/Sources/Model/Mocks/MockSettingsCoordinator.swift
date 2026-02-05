//
//  MockSettingsCoordinator.swift
//  Model
//
//  Mock implementation of SettingsCoordinator for testing
//

import Foundation

@MainActor
public final class MockSettingsCoordinator: SettingsCoordinator {

    public var dismissCalled = false
    public var logoutCalled = false

    public init() {}

    public func dismiss() {
        dismissCalled = true
    }

    public func logout() {
        logoutCalled = true
    }

    public func reset() {
        dismissCalled = false
        logoutCalled = false
    }
}
