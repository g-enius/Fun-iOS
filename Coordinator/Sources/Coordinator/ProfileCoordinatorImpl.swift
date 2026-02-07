//
//  ProfileCoordinatorImpl.swift
//  Coordinator
//
//  Coordinator implementation for Profile screen (modal)
//

import UIKit

import FunModel
import FunViewModel

public final class ProfileCoordinatorImpl: BaseCoordinator, ProfileCoordinator {

    // MARK: - Properties

    /// Callback to notify parent coordinator of logout
    public var onLogout: (() -> Void)?

    // MARK: - Initialization

    override public init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }

    // MARK: - ProfileCoordinator

    public func dismiss() {
        navigationController.dismiss(animated: true)
    }

    public func logout() {
        navigationController.dismiss(animated: true) { [weak self] in
            self?.onLogout?()
        }
    }
}
