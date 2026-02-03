//
//  ItemsCoordinatorImpl.swift
//  Coordinator
//
//  Coordinator implementation for Items tab
//

import UIKit
import FunViewModel
import FunModel
import FunUI

public final class ItemsCoordinatorImpl: BaseCoordinator, ItemsCoordinator {

    // MARK: - Child Coordinators

    private var detailCoordinator: DetailCoordinatorImpl?

    // MARK: - Tab Bar

    private weak var tabBarViewModel: HomeTabBarViewModel?

    // MARK: - Initialization

    public init(navigationController: UINavigationController, tabBarViewModel: HomeTabBarViewModel) {
        self.tabBarViewModel = tabBarViewModel
        super.init(navigationController: navigationController)
    }

    override public func start() {
        let viewModel = ItemsViewModel(coordinator: self)
        let viewController = ItemsViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }

    // MARK: - ItemsCoordinator

    public func showDetail(for item: FeaturedItem) {
        let coordinator = DetailCoordinatorImpl(
            navigationController: navigationController,
            tabBarViewModel: tabBarViewModel
        )
        detailCoordinator = coordinator

        let viewModel = DetailViewModel(
            item: item,
            coordinator: coordinator,
            tabBarViewModel: tabBarViewModel
        )
        let viewController = DetailViewController(viewModel: viewModel)
        safePush(viewController)
    }
}
