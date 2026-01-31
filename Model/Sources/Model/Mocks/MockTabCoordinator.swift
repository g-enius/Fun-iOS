//
//  MockTabCoordinator.swift
//  Model
//
//  Mock coordinator for testing ViewModels
//

import Foundation

@MainActor
public final class MockTabCoordinator: Tab1Coordinator, Tab2Coordinator, Tab3Coordinator {
    public var showDetailCalled = false
    public var showDetailItem: String?
    public var showProfileCalled = false
    public var showSettingsCalled = false
    public var switchToTabCalled = false
    public var switchToTabIndex: Int?

    public init() {}

    // Tab1Coordinator
    public func showDetail(for item: String) {
        showDetailCalled = true
        showDetailItem = item
    }

    public func showProfile() {
        showProfileCalled = true
    }

    public func showSettings() {
        showSettingsCalled = true
    }

    // Tab2Coordinator
    public func switchToTab(_ index: Int) {
        switchToTabCalled = true
        switchToTabIndex = index
    }
}
