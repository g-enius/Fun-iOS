//
//  Tab5ViewModel.swift
//  ViewModel
//
//  ViewModel for Tab5 (Settings) screen
//

import Foundation
import Combine
import FunModel
import FunCore

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
            UserDefaults.standard.set(isDarkModeEnabled, forKey: .darkModeEnabled)
            AppSettingsPublisher.shared.notifySettingsChanged()
        }
    }

    @Published public var featuredCarouselEnabled: Bool = false {
        didSet { featureToggleService.featuredCarousel = featuredCarouselEnabled }
    }

    // MARK: - Initialization

    public init(coordinator: Tab5Coordinator?) {
        self.coordinator = coordinator
        self.isDarkModeEnabled = UserDefaults.standard.bool(forKey: .darkModeEnabled)
        self.featuredCarouselEnabled = featureToggleService.featuredCarousel
    }

    // MARK: - Actions

    public func resetDarkMode() {
        isDarkModeEnabled = false
        logger.log("Dark mode reset")
    }

    public func resetFeatureToggles() {
        featuredCarouselEnabled = true
        logger.log("Feature toggles reset")
    }
}
