//
//  ProfileCoordinatorImpl.swift
//  Coordinator
//
//  Coordinator implementation for Profile screen (modal)
//

import UIKit
import FunViewModel
import FunModel
import FunUI

public final class ProfileCoordinatorImpl: BaseCoordinator, ProfileCoordinator {

    // MARK: - Child Coordinators

    private var settingsCoordinator: SettingsCoordinatorImpl?

    // MARK: - Tab Bar

    private weak var tabBarViewModel: HomeTabBarViewModel?

    // MARK: - Initialization

    public init(navigationController: UINavigationController, tabBarViewModel: HomeTabBarViewModel?) {
        self.tabBarViewModel = tabBarViewModel
        super.init(navigationController: navigationController)
    }

    // MARK: - ProfileCoordinator

    public func dismiss() {
        // The navigationController IS the presented modal, so dismiss it directly
        navigationController.dismiss(animated: true)
    }

    public func showSettings() {
        let settingsNavController = UINavigationController()
        let coordinator = SettingsCoordinatorImpl(navigationController: settingsNavController)
        settingsCoordinator = coordinator

        let viewModel = SettingsViewModel(coordinator: coordinator)
        let viewController = SettingsViewController(viewModel: viewModel)

        // Add Done button for modal dismissal
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissSettings)
        )

        settingsNavController.setViewControllers([viewController], animated: false)

        // Present settings over the profile modal
        navigationController.present(settingsNavController, animated: true)
    }

    @objc private func dismissSettings() {
        // Dismiss the settings modal (presented on top of profile)
        navigationController.presentedViewController?.dismiss(animated: true)
    }

    public func dismissAndSwitchToItems() {
        // First dismiss the profile modal, then switch to Items tab
        navigationController.dismiss(animated: true) { [weak self] in
            self?.tabBarViewModel?.switchToTab(1) // Items tab is now index 1
        }
    }
}
