//
//  Tab3ViewModel.swift
//  ViewModel
//
//  ViewModel for Tab3 (Items) screen
//

import Foundation
import Combine
import FunModel
import FunCore

@MainActor
public class Tab3ViewModel: ObservableObject {

    // MARK: - Coordinator

    private weak var coordinator: Tab3Coordinator?

    // MARK: - Services

    @Service(.logger) private var logger: LoggerService
    @Service(.favorites) private var favoritesService: FavoritesServiceProtocol

    // MARK: - Published State

    @Published public var items: [FeaturedItem] = []
    @Published public private(set) var favoriteIds: Set<String> = []

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(coordinator: Tab3Coordinator?) {
        self.coordinator = coordinator
        loadItems()
        observeFavoritesChanges()
    }

    // MARK: - Setup

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

    // MARK: - Data Loading

    public func loadItems() {
        // Use the same items as the carousel for consistency
        items = FeaturedItem.allCarouselSets.flatMap { $0 }
    }

    // MARK: - Favorites

    public func isFavorited(_ itemId: String) -> Bool {
        favoriteIds.contains(itemId)
    }

    public func toggleFavorite(for itemId: String) {
        favoritesService.toggleFavorite(forKey: itemId)
    }

    // MARK: - Actions

    public func didSelectItem(_ item: FeaturedItem) {
        logger.log("Item selected: \(item.title)")
        coordinator?.showDetail(for: item)
    }
}
