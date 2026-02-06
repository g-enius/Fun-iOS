//
//  MockProfileCoordinator.swift
//  Model
//
//  Mock implementation of ProfileCoordinator for testing
//

import Foundation

@MainActor
public final class MockProfileCoordinator: ProfileCoordinator {

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
