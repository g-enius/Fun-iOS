//
//  SettingsCoordinatorImpl.swift
//  Coordinator
//
//  Coordinator implementation for Settings tab
//

import UIKit
import FunViewModel
import FunModel
import FunUI

public final class SettingsCoordinatorImpl: BaseCoordinator, SettingsCoordinator {

    // MARK: - Properties

    /// Callback to notify parent coordinator of logout
    public var onLogout: (() -> Void)?

    // MARK: - Initialization

    override public init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }

    override public func start() {
        let viewModel = SettingsViewModel(coordinator: self)
        let viewController = SettingsViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }

    // MARK: - SettingsCoordinator

    public func dismiss() {
        safePop()
    }

    public func logout() {
        onLogout?()
    }
}
