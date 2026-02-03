//
//  HomeViewSnapshotTests.swift
//  UI
//
//  Snapshot tests for HomeView (Home screen)
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
final class HomeViewSnapshotTests: XCTestCase {

    override func setUp() {
        super.setUp()
        ServiceLocator.shared.register(MockLoggerService(), for: .logger)
        ServiceLocator.shared.register(MockFeatureToggleService(), for: .featureToggles)
        ServiceLocator.shared.register(MockFavoritesService(), for: .favorites)
    }

    func testHomeView_withCarouselEnabled() {
        let viewModel = HomeViewModel(coordinator: nil)
        viewModel.isCarouselEnabled = true

        let view = HomeView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)

        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro))
    }

    func testHomeView_withCarouselDisabled() {
        let viewModel = HomeViewModel(coordinator: nil)
        viewModel.isCarouselEnabled = false

        let view = HomeView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)

        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro))
    }

    func testHomeView_darkMode() {
        let viewModel = HomeViewModel(coordinator: nil)
        viewModel.isCarouselEnabled = true

        let view = HomeView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.overrideUserInterfaceStyle = .dark
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)

        assertSnapshot(of: hostingController, as: .image(on: .iPhone13Pro))
    }
}

// MARK: - Mock Services for Testing

@MainActor
private class MockFeatureToggleService: FeatureToggleServiceProtocol {
    var featuredCarousel: Bool = true

    var featureTogglesDidChange: AnyPublisher<Void, Never> {
        Empty().eraseToAnyPublisher()
    }
}
