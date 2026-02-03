//
//  SettingsViewModel.swift
//  ViewModel
//
//  ViewModel for Settings screen
//

import Foundation
import Combine
import FunModel
import FunCore

@MainActor
public class SettingsViewModel: ObservableObject {

    // MARK: - Coordinator

    private weak var coordinator: SettingsCoordinator?

    // MARK: - Services

    @Service(.logger) private var logger: LoggerService

    // We need direct access to the service for mutations
    private var featureToggleService: FeatureToggleServiceProtocol {
        ServiceLocator.shared.resolve(for: .featureToggles)
    }

    // MARK: - Published State

    @Published public var isDarkModeEnabled: Bool = false {
        didSet {
            UserDefaults.standard.set(isDarkModeEnabled, forKey: .darkModeEnabled)
            AppSettingsPublisher.shared.notifySettingsChanged()
        }
    }

    @Published public var featuredCarouselEnabled: Bool = false {
        didSet { featureToggleService.featuredCarousel = featuredCarouselEnabled }
    }

    @Published public var simulateErrorsEnabled: Bool = false {
        didSet { featureToggleService.simulateErrors = simulateErrorsEnabled }
    }

    // MARK: - Initialization

    public init(coordinator: SettingsCoordinator?) {
        self.coordinator = coordinator
        self.isDarkModeEnabled = UserDefaults.standard.bool(forKey: .darkModeEnabled)
        self.featuredCarouselEnabled = featureToggleService.featuredCarousel
        self.simulateErrorsEnabled = featureToggleService.simulateErrors
    }

    // MARK: - Actions

    public func resetDarkMode() {
        isDarkModeEnabled = false
        logger.log("Dark mode reset")
    }

    public func resetFeatureToggles() {
        featuredCarouselEnabled = true
        simulateErrorsEnabled = false
        logger.log("Feature toggles reset")
    }
}
