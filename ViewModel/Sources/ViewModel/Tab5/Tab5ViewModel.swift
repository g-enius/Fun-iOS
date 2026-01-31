//
//  Tab5ViewModel.swift
//  ViewModel
//
//  ViewModel for Tab5 (Settings) screen
//

import Foundation
import Combine
import FunModel
import FunToolbox

@MainActor
public class Tab5ViewModel: ObservableObject {

    // MARK: - Coordinator

    private weak var coordinator: Tab5Coordinator?

    // MARK: - Services

    @Service(.logger) private var logger: LoggerService

    // We need direct access to the service for mutations
    private var featureToggleService: FeatureToggleServiceProtocol {
        ServiceLocator.shared.resolve(for: .featureToggles)
    }

    // MARK: - Published State

    @Published public var isDarkModeEnabled: Bool = false {
        didSet {
            UserDefaults.standard.set(isDarkModeEnabled, forKey: "app.darkModeEnabled")
            NotificationCenter.default.post(name: NSNotification.Name("AppSettingsChanged"), object: nil)
        }
    }

    @Published public var featuredCarouselEnabled: Bool = false {
        didSet {
            let service = featureToggleService
            service.featuredCarousel = featuredCarouselEnabled
        }
    }

    @Published public var analyticsEnabled: Bool = false {
        didSet {
            let service = featureToggleService
            service.featureAnalytics = analyticsEnabled
            logger.log("Analytics \(analyticsEnabled ? "enabled" : "disabled")")
        }
    }

    @Published public var debugModeEnabled: Bool = false {
        didSet {
            let service = featureToggleService
            service.featureDebugMode = debugModeEnabled
            logger.log("Debug mode \(debugModeEnabled ? "enabled" : "disabled")")
        }
    }

    // MARK: - Initialization

    public init(coordinator: Tab5Coordinator?) {
        self.coordinator = coordinator

        // Load initial values
        self.isDarkModeEnabled = UserDefaults.standard.bool(forKey: "app.darkModeEnabled")
        self.featuredCarouselEnabled = featureToggleService.featuredCarousel
        self.analyticsEnabled = featureToggleService.featureAnalytics
        self.debugModeEnabled = featureToggleService.featureDebugMode
    }

    // MARK: - Actions

    public func resetDarkMode() {
        isDarkModeEnabled = false
        logger.log("Dark mode reset")
    }

    public func resetFeatureToggles() {
        featuredCarouselEnabled = true
        analyticsEnabled = false
        debugModeEnabled = false
        logger.log("Feature toggles reset")
    }
}
