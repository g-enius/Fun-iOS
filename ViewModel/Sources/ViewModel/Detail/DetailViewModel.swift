//
//  DetailViewModel.swift
//  ViewModel
//
//  ViewModel for Detail screen
//

import Foundation
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
    @Published public var isFavorited: Bool = false

    // MARK: - Initialization

    public init(itemTitle: String, category: String, coordinator: DetailCoordinator?, tabBarViewModel: HomeTabBarViewModel? = nil) {
        self.itemTitle = itemTitle
        self.category = category
        self.coordinator = coordinator
        self.tabBarViewModel = tabBarViewModel
        self.isFavorited = favoritesService.isFavorited(itemTitle)
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
        favoritesService.toggleFavorite(forKey: itemTitle)
        isFavorited = favoritesService.isFavorited(itemTitle)
        logger.log("Favorite toggled for \(itemTitle): \(isFavorited)")
    }

    public func didTapSwitchToTab2() {
        tabBarViewModel?.switchToTab(1)
    }
}
