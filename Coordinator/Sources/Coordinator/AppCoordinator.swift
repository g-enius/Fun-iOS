//
//  AppCoordinator.swift
//  Coordinator
//
//  Main coordinator for the application
//

import UIKit
import FunUI
import FunViewModel
import FunCore

/// Main app coordinator that manages the root navigation
public final class AppCoordinator: BaseCoordinator {

    // MARK: - Child Coordinators

    // Store child coordinators to prevent deallocation
    // ViewModels hold weak references, so coordinators must be retained
    private var homeCoordinator: HomeCoordinatorImpl?
    private var itemsCoordinator: ItemsCoordinatorImpl?
    private var settingsCoordinator: SettingsCoordinatorImpl?

    // Store tab bar view model for tab switching
    private var tabBarViewModel: HomeTabBarViewModel?

    override public func start() {
        // Create navigation controllers for each tab (3 tabs: Home, Items, Settings)
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
}
