//
//  DetailViewModel.swift
//  ViewModel
//
//  ViewModel for Detail screen
//

import Foundation
import Combine
import FunModel
import FunCore

@MainActor
public class DetailViewModel: ObservableObject {

    // MARK: - Coordinator

    private weak var coordinator: DetailCoordinator?
    private weak var tabBarViewModel: HomeTabBarViewModel?

    // MARK: - Services

    @Service(.logger) private var logger: LoggerService
    @Service(.favorites) private var favoritesService: FavoritesServiceProtocol

    // MARK: - Published State

    @Published public var itemTitle: String
    @Published public var category: String
    @Published public var itemDescription: String
    @Published public var isFavorited: Bool = false

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private var itemId: String

    // MARK: - Initialization

    public init(item: FeaturedItem, coordinator: DetailCoordinator?, tabBarViewModel: HomeTabBarViewModel? = nil) {
        self.itemTitle = item.title
        self.category = item.category
        self.itemId = item.id
        self.itemDescription = TechnologyDescriptions.description(for: item.id)
        self.coordinator = coordinator
        self.tabBarViewModel = tabBarViewModel
        self.isFavorited = favoritesService.isFavorited(itemId)
        observeFavoritesChanges()
    }

    // MARK: - Setup

    private func observeFavoritesChanges() {
        favoritesService.favoritesDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                guard let self else { return }
                self.isFavorited = favorites.contains(self.itemId)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    public func didTapBack() {
        coordinator?.dismiss()
    }

    public func didTapShare() {
        let shareText = "Check out \(itemTitle)!"
        coordinator?.share(text: shareText)
    }

    public func didTapToggleFavorite() {
        favoritesService.toggleFavorite(forKey: itemId)
        logger.log("Favorite toggled for \(itemTitle): \(isFavorited)")
    }

    public func didTapSwitchToTab2() {
        tabBarViewModel?.switchToTab(1)
    }
}
