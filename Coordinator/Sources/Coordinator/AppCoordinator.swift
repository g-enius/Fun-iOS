//
//  AppCoordinator.swift
//  Coordinator
//
//  Main coordinator for the application
//

import UIKit
import FunUI
import FunViewModel
import FunModel
import FunCore

/// Main app coordinator that manages the root navigation and app flow
public final class AppCoordinator: BaseCoordinator {

    // MARK: - App Flow State

    private var currentFlow: AppFlow = .login

    // MARK: - Child Coordinators

    private var loginCoordinator: LoginCoordinatorImpl?
    private var homeCoordinator: HomeCoordinatorImpl?
    private var itemsCoordinator: ItemsCoordinatorImpl?
    private var settingsCoordinator: SettingsCoordinatorImpl?

    // Store tab bar view model for tab switching
    private var tabBarViewModel: HomeTabBarViewModel?

    // MARK: - Start

    override public func start() {
        switch currentFlow {
        case .login:
            showLoginFlow()
        case .main:
            showMainFlow()
        }
    }

    // MARK: - Flow Management

    private func showLoginFlow() {
        // Clear any existing main flow coordinators
        clearMainFlowCoordinators()

        let loginCoordinator = LoginCoordinatorImpl(navigationController: navigationController)
        loginCoordinator.onLoginSuccess = { [weak self] in
            self?.transitionToMainFlow()
        }
        self.loginCoordinator = loginCoordinator
        loginCoordinator.start()
    }

    private func showMainFlow() {
        // Clear login coordinator
        loginCoordinator = nil

        // Create navigation controllers for each tab
        let homeNavController = UINavigationController()
        let itemsNavController = UINavigationController()
        let settingsNavController = UINavigationController()

        // Configure tab bar items with icons and titles
        homeNavController.tabBarItem = UITabBarItem(
            title: L10n.Tabs.home,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        itemsNavController.tabBarItem = UITabBarItem(
            title: L10n.Tabs.items,
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet")
        )

        settingsNavController.tabBarItem = UITabBarItem(
            title: L10n.Tabs.settings,
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )

        // Create view model for tab bar
        let tabBarViewModel = HomeTabBarViewModel()
        self.tabBarViewModel = tabBarViewModel

        // Create and store coordinators for each tab
        let homeCoordinator = HomeCoordinatorImpl(
            navigationController: homeNavController,
            tabBarViewModel: tabBarViewModel
        )
        let itemsCoordinator = ItemsCoordinatorImpl(
            navigationController: itemsNavController,
            tabBarViewModel: tabBarViewModel
        )
        let settingsCoordinator = SettingsCoordinatorImpl(
            navigationController: settingsNavController
        )

        // Set up logout callback
        settingsCoordinator.onLogout = { [weak self] in
            self?.transitionToLoginFlow()
        }

        // Store coordinators to prevent deallocation
        self.homeCoordinator = homeCoordinator
        self.itemsCoordinator = itemsCoordinator
        self.settingsCoordinator = settingsCoordinator

        // Start each coordinator's flow
        homeCoordinator.start()
        itemsCoordinator.start()
        settingsCoordinator.start()

        // Create tab bar with view model and navigation controllers
        let tabBarController = HomeTabBarController(
            viewModel: tabBarViewModel,
            tabNavigationControllers: [
                homeNavController,
                itemsNavController,
                settingsNavController
            ]
        )

        // Set as root (tab bar doesn't push, it's the container)
        navigationController.setViewControllers([tabBarController], animated: false)
    }

    // MARK: - Flow Transitions

    private func transitionToMainFlow() {
        currentFlow = .main
        showMainFlow()
    }

    private func transitionToLoginFlow() {
        currentFlow = .login
        showLoginFlow()
    }

    // MARK: - Cleanup

    private func clearMainFlowCoordinators() {
        homeCoordinator = nil
        itemsCoordinator = nil
        settingsCoordinator = nil
        tabBarViewModel = nil
    }
}
