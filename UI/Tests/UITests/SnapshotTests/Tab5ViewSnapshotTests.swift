//
//  Tab5ViewSnapshotTests.swift
//  UI
//
//  Snapshot tests for Tab5View (Settings screen)
//

import XCTest
import SwiftUI
import SnapshotTesting
import Combine
@testable import FunUI
@testable import FunViewModel
@testable import FunModel
@testable import FunCore

@MainActor
final class Tab5ViewSnapshotTests: XCTestCase {

    override func setUp() {
        super.setUp()
        ServiceLocator.shared.register(MockLoggerService(), for: .logger)
        ServiceLocator.shared.register(MockFeatureToggleServiceForSettings(), for: .featureToggles)
    }

    func testTab5View_defaultState() {
        let viewModel = Tab5ViewModel(coordinator: nil)

        let view = Tab5View(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)

        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro))
    }

    func testTab5View_darkModeEnabled() {
        let viewModel = Tab5ViewModel(coordinator: nil)
        viewModel.isDarkModeEnabled = true

        let view = Tab5View(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.overrideUserInterfaceStyle = .dark
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)

        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro))
    }

    func testTab5View_carouselEnabled() {
        let viewModel = Tab5ViewModel(coordinator: nil)
        viewModel.featuredCarouselEnabled = true

        let view = Tab5View(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)

        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro))
    }

    func testTab5View_carouselDisabled() {
        let viewModel = Tab5ViewModel(coordinator: nil)
        viewModel.featuredCarouselEnabled = false

        let view = Tab5View(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)

        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro))
    }
}

// MARK: - Mock Services for Testing

@MainActor
private class MockFeatureToggleServiceForSettings: FeatureToggleServiceProtocol {
    var featuredCarousel: Bool = true

    var featureTogglesDidChange: AnyPublisher<Void, Never> {
        Empty().eraseToAnyPublisher()
    }
}
