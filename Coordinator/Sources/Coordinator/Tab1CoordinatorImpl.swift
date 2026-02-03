//
//  Tab1CoordinatorImpl.swift
//  Coordinator
//
//  Coordinator implementation for Tab1 (Home)
//

import UIKit
import FunViewModel
import FunModel
import FunUI

public final class Tab1CoordinatorImpl: BaseCoordinator, Tab1Coordinator {

    // MARK: - Child Coordinators

    // Store to prevent deallocation, ViewModels hold weak refs
    private var detailCoordinator: DetailCoordinatorImpl?
    private var tab5Coordinator: Tab5CoordinatorImpl?
    private var profileCoordinator: ProfileCoordinatorImpl?

    // MARK: - Tab Bar

    private weak var tabBarViewModel: HomeTabBarViewModel?

    // MARK: - Initialization

    public init(navigationController: UINavigationController, tabBarViewModel: HomeTabBarViewModel) {
        self.tabBarViewModel = tabBarViewModel
        super.init(navigationController: navigationController)
    }

    override public func start() {
        let viewModel = Tab1ViewModel(coordinator: self, tabBarViewModel: tabBarViewModel)
        let viewController = Tab1ViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }

    // MARK: - Tab1Coordinator

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

    public func showProfile() {
        let profileNavController = UINavigationController()
        let coordinator = ProfileCoordinatorImpl(navigationController: profileNavController)
        profileCoordinator = coordinator

        let viewModel = ProfileViewModel(coordinator: coordinator)
        let viewController = ProfileViewController(viewModel: viewModel)
        profileNavController.setViewControllers([viewController], animated: false)
        safePresent(profileNavController)
    }

    public func showSettings() {
        let settingsNavController = UINavigationController()
        let coordinator = Tab5CoordinatorImpl(navigationController: settingsNavController)
        tab5Coordinator = coordinator

        let viewModel = Tab5ViewModel(coordinator: coordinator)
        let viewController = Tab5ViewController(viewModel: viewModel)

        // Add Done button for modal dismissal
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissSettings)
        )

        settingsNavController.setViewControllers([viewController], animated: false)
        safePresent(settingsNavController)
    }

    @objc private func dismissSettings() {
        navigationController.dismiss(animated: true)
    }
}
