//
//  HomeViewModel.swift
//  ViewModel
//
//  ViewModel for Home screen
//

import Foundation
import Combine
import FunModel
import FunCore

@MainActor
public class HomeViewModel: ObservableObject {

    // MARK: - Coordinator

    private weak var coordinator: HomeCoordinator?

    // MARK: - Services

    @Service(.logger) private var logger: LoggerService
    @Service(.favorites) private var favoritesService: FavoritesServiceProtocol

    /// Direct access to feature toggle service for reading current state
    private var featureToggleService: FeatureToggleServiceProtocol {
        ServiceLocator.shared.resolve(for: .featureToggles)
    }

    // MARK: - Published State

    @Published public var featuredItems: [[FeaturedItem]] = []
    @Published public var currentCarouselIndex: Int = 0
    @Published public var isLoading: Bool = false
    @Published public var isRefreshing: Bool = false
    @Published public var isCarouselEnabled: Bool = true
    @Published public private(set) var favoriteIds: Set<String> = []

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private var hasLoadedInitialData: Bool = false

    // MARK: - Initialization

    public init(coordinator: HomeCoordinator?) {
        self.coordinator = coordinator

        // Load initial carousel state from feature toggle
        isCarouselEnabled = featureToggleService.featuredCarousel

        observeFeatureToggleChanges()
        observeFavoritesChanges()

        // Load data asynchronously on init
        Task {
            await loadFeaturedItems()
        }
    }

    // MARK: - Feature Toggle Observation (Combine)

    private func observeFeatureToggleChanges() {
        featureToggleService.featureTogglesDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.refreshFeatureToggles()
            }
            .store(in: &cancellables)
    }

    // MARK: - Favorites Observation

    private func observeFavoritesChanges() {
        // Initialize with current favorites
        favoriteIds = favoritesService.favorites

        // Observe future changes
        favoritesService.favoritesDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newFavorites in
                self?.favoriteIds = newFavorites
            }
            .store(in: &cancellables)
    }

    // MARK: - Favorites

    public func isFavorited(_ itemId: String) -> Bool {
        favoriteIds.contains(itemId)
    }

    public func toggleFavorite(for itemId: String) {
        favoritesService.toggleFavorite(forKey: itemId)
        logger.log("Toggled favorite for: \(itemId)")
    }

    private func refreshFeatureToggles() {
        let newValue = featureToggleService.featuredCarousel
        if isCarouselEnabled != newValue {
            isCarouselEnabled = newValue
            logger.log("Carousel visibility changed to: \(newValue)")
        }
    }

    // MARK: - Data Loading

    /// Load featured items with simulated network delay
    public func loadFeaturedItems() async {
        // Show loading only for initial load
        if !hasLoadedInitialData {
            isLoading = true
        }

        logger.log("Loading featured items...")

        // Simulate network delay (500ms - 1.5s)
        let delay = UInt64.random(in: 500_000_000...1_500_000_000)
        try? await Task.sleep(nanoseconds: delay)

        // Use static FeaturedItem data showcasing technologies used in this demo
        featuredItems = FeaturedItem.allCarouselSets
        isLoading = false
        isRefreshing = false
        hasLoadedInitialData = true

        logger.log("Featured items loaded: \(featuredItems.flatMap { $0 }.count) items")
    }

    /// Pull-to-refresh handler
    public func refresh() async {
        isRefreshing = true
        logger.log("Pull to refresh triggered")

        // Simulate network delay
        let delay = UInt64.random(in: 800_000_000...1_200_000_000)
        try? await Task.sleep(nanoseconds: delay)

        // Reload data (could fetch new data from server)
        await loadFeaturedItems()
    }

    // MARK: - Actions

    public func didTapFeaturedItem(_ item: FeaturedItem) {
        logger.log("Featured item tapped: \(item.title)")
        coordinator?.showDetail(for: item)
    }

    public func didTapProfile() {
        logger.log("Profile tapped")
        coordinator?.showProfile()
    }
}
