//
//  HomeCoordinatorImpl.swift
//  Coordinator
//
//  Coordinator implementation for Home tab
//

import UIKit

import FunModel
import FunUI
import FunViewModel

public final class HomeCoordinatorImpl: BaseCoordinator, HomeCoordinator {

    // MARK: - Properties

    /// Callback to notify parent coordinator of logout
    public var onLogout: (() -> Void)?

    // MARK: - Child Coordinators

    // Store to prevent deallocation, ViewModels hold weak refs
    private var detailCoordinator: DetailCoordinatorImpl?
    private var profileCoordinator: ProfileCoordinatorImpl?

    override public func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }

    // MARK: - HomeCoordinator

    public func showDetail(for item: FeaturedItem) {
        let coordinator = DetailCoordinatorImpl(
            navigationController: navigationController
        )
        detailCoordinator = coordinator

        let viewModel = DetailViewModel(
            item: item,
            coordinator: coordinator
        )
        let viewController = DetailViewController(viewModel: viewModel)
        safePush(viewController)
    }

    public func showProfile() {
        let profileNavController = UINavigationController()
        let coordinator = ProfileCoordinatorImpl(navigationController: profileNavController)
        coordinator.onLogout = { [weak self] in
            self?.onLogout?()
        }
        profileCoordinator = coordinator

        let viewModel = ProfileViewModel(coordinator: coordinator)
        let viewController = ProfileViewController(viewModel: viewModel)
        profileNavController.setViewControllers([viewController], animated: false)
        safePresent(profileNavController)
    }
}
